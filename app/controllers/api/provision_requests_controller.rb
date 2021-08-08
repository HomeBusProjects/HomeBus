# frozen_string_literal: true

# stripped down controller that handles provision_request operations from devices

require 'securerandom'

class Api::ProvisionRequestsController < Api::ApplicationController
  before_action -> { api_authenticate!('provision_request:create') }, only: [ :create ]
  before_action -> { api_authenticate!('provision_request:manage') }, only: [ :show, :update, :destroy ]

  before_action :set_provision_request, except: [ :index, :create ]

  # GET /api/provision_requests
  def show
    response = {
      provision_request: {
        id: @provision_request.id,
        token: @token.id,
        name: @provision_request.friendly_name,
        publishes: @provision_request.publishes,
        consumes: @provision_request.consumes,
        devices: []
      }
    }

    if @provision_request.accepted?
      @provision_request.devices.each do |d|
        response[:devices].push(device.to_json)
      end

      broker = Broker.first
      response[:credentials] = {
        mqtt_username: @provision_request.broker_account.id,
        mqtt_password: @provision_request.broker_account.enc_password
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
    pr = ProvisionRequest.create(
      friendly_name: params[:name],
      status: :unanswered,

      consumes: params[:consumes],
      publishes: params[:publishes],

      ip_address: request.remote_ip,
      user: @token.user,
      network: @token.network
    )

    if pr
      response = {
        provision_request: pr.to_json,
        devices: []
      }

      response[:provision_request][:token] = pr.token.id

      params[:devices].each do |d|
        device = Device.create({ provision_request: pr,
                                 friendly_name: "#{d[:identity][:manufacturer]}-#{d[:identity][:model]}-#{d[:identity][:serial_number]}",
                                 manufacturer: d[:identity][:manufacturer],
                                 model: d[:identity][:model],
                                 serial_number:  d[:identity][:serial_number],
                                 pin:  d[:identity][:pin],
                                 public: false
                               })
        response[:devices].push(device.to_json)
      end

      if pr.accepted?
        response[:broker] = pr.network.broker.to_json
        response[:credentials] = pr.broker_account.to_json
      else
        response[:retry_interval] = 30
      end

      # return 202 Accepted to indicate that the client should come back later to get broker credentials
      render json: response, status: :accepted
    else
      render json: 'ProvisionRequest creation failure', status: 503
    end
  end

  # PATCH/PUT /api/provision_requests/1.json
  def update
    p = provision_request_params

    if @provision_request.update(p)
      PublishDevicesJob.perform_later(@provision_request.network)

      render json: @provision_request.to_json, status: :ok
    else
      render json: 'ProvisionRequest update failure', status: 503
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_provision_request
    if @token.provision_request_id != params[:id]
      Rails.logger.error 'BAD ID'

      unauthorized_token!('provision_request:manage') 
    end

    @provision_request = ProvisionRequest.find(params[:id])

    if @provision_request.nil?
      render json: 'not found', status: 404
    end
  end
end
