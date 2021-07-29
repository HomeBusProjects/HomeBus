# frozen_string_literal: true

# stripped down controller that handles provision_request operations from devices

require 'securerandom'

class Api::ProvisionRequestsController < Api::ApplicationController
  before_action -> { api_authenticate!('provision_request:create') }, only: [ :create ]
  before_action -> { api_authenticate!('provision_request:manage') }, only: [ :show, :update, :destroy ]

  # GET /api/provision_requests
  def show
    Rails.logger.info 'API/PR SHOW'

    if @token.scope != 'provision_request:manage'
      Rails.logger.error 'BAD SCOPE'

      unauthorized_token!('provision_request:manage')
      return
    end

    if @token.provision_request_id != params[:id]
      Rails.logger.error 'BAD ID'

      unauthorized_token!('provision_request:manage') 
     return
    end

    pr = ProvisionRequest.find params[:id]
    if pr.nil?
      render json: 'not found', status: 404
      return
    end

    Rails.logger.info "found PR!"
    Rails.logger.info pr.inspect

    response = {
      id: pr.id,
      token: @token.id
    }

    if pr.accepted?
      broker = Broker.first
      response[:credentials] = {
        mqtt_username: pr.account_id,
        mqtt_password: pr.account_password
      }

      response[:broker] = {
        mqtt_hostname: broker.name,
        insecure_mqtt_port: 1883,
        secure_mqtt_port: 8883
      }

      render json: response, status: 200
    else
      response[:retry_interval] = 30
      render json: response, status: 201
    end

  end

  # POST /api/provision_requests
  def create
    Rails.logger.info 'params'
    Rails.logger.info params
    Rails.logger.info 'token'
    Rails.logger.info @token.inspect
    Rails.logger.info 'headers'
    Rails.logger.info request.headers
    pp request.headers

    pr = ProvisionRequest.create(
      friendly_name: params[:name],
      status: :unanswered,

      ro_ddcs: params[:ro_ddcs],
      wo_ddcs: params[:wo_ddcs],

      ip_address: request.remote_ip,
      user: @token.user,
      network: @token.network
    )

    Rails.logger.info 'created pr'
    Rails.logger.info pr.inspect
    Rails.logger.error pr.errors.full_messages

    response = get_response(pr)
    response[:retry_interval] = 30

    # return 202 Accepted to indicate that the client should come back later to get broker credentials
    render json: response, status: :accepted
  end

  # PATCH/PUT /api/provision_requests/1.json
  def update
    p = provision_request_params
    # validate params, are we allowed to modify these?

    if @provision_request.update(p)
      PublishDevicesJob.perform_later(@provision_request.network)

      format.json { render :show, status: :ok, location: @provision_request }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_provision_request
    @provision_request = ProvisionRequest.find(params[:id])
  end


  def get_response(pr)
    response_token = Token.create({ name: params[:name],
                                    scope: 'provision_request:manage',
                                    enabled: true,
                                    user: @token.user,
                                    provision_request: pr,
                                    network: pr.network
                                  })
   devices = []
   params[:devices].each do |d|
     device = Device.create({ provision_request: pr,
                              friendly_name: "#{d[:identity][:manufacturer]}-#{d[:identity][:model]}-#{d[:identity][:serial_number]}",
                              manufacturer: d[:identity][:manufacturer],
                              model: d[:identity][:model],
                              serial_number:  d[:identity][:serial_number],
                              pin:  d[:identity][:pin],
                              public: false
                             })
     devices.push({ uuid: device.id, identity: d[:identity] })
   end

   response = {
     id: pr.id,
     token: response_token.id,
     devices: devices,
    }

   response
  end
end
