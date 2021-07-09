# frozen_string_literal: true

# stripped down controller that handles provision_request operations from devices

require 'securerandom'

class ProvisionRequestsTokenController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate!

  # POST /api/provision_requests.json
  def create
    p = provision_request_params
    p[:friendly_name] = "#{p[:identity][:manufacturer]}-#{p[:identity][:model]}-#{p[:identity][:serial_number]}"

    @provision_request = ProvisionRequest.new(p)
    @provision_request.ip_address = request.remote_ip
    @provision_request.user = current_user

    respond_to do |format|
      if @provision_request.save
        flash_message 'success', 'Provision request was successfully created.'

        format.json { render :show, status: :created, location: @provision_request }
      else
        format.json { render json: @provision_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/provision_requests/1.json
  def update
    p = provision_request_params
    # validate params, are we allowed to modify these?

    respond_to do |format|
      if @provision_request.update(p)
        PublishDevicesJob.perform_later(@provision_request.network)

        flash_message 'success', 'Provision request was successfully updated.'

        format.json { render :show, status: :ok, location: @provision_request }
      else
        format.json { render json: @provision_request.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def authenticate!
    if request.format != 'application/json'
      return false
    end

    authenticate_with_http_token do |token, options|
      t = Token.find token
    end
      
    unless t
      render_unauthorized
      return false
    end

    true
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm=ProvisionRequest'
    render json: 'invalid token', status: 401
  end

  def render_expired
    self.headers['WWW-Authenticate'] = 'Token realm=ProvisionRequest'
    render json: 'expired token', status: 401
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_provision_request
    @provision_request = ProvisionRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def provision_request_params
    arrayize_ddcs!(params.require(:provision_request).permit(identity: [
                                                               :pin,
                                                               :manufacturer,
                                                               :model,
                                                               :serial_number
                                                             ],
                                                             :requested_uuid_count,
                                                             :wo_ddcs,
                                                             :ro_ddcs)
  end

  def arrayize_ddcs!(p)
    wo_ddcs = p[:wo_ddcs]
    p.merge!({ wo_ddcs: wo_ddcs.split }) if wo_ddcs.present?

    ro_ddcs = p[:ro_ddcs]
    p.merge!({ ro_ddcs: ro_ddcs.split }) if ro_ddcs.present?

    p
  end
end
