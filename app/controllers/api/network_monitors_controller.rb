# frozen_string_literal: true

# stripped down controller that handles provision_request operations from devices

require 'securerandom'

class Api::NetworkMonitorsController < Api::ApplicationController
  before_action -> { api_authenticate!('network_monitor:refresh') }, only: [ :show, :update, :destroy ]

  before_action :set_network_monitor

  # GET /api/network_monitors
  def show
    @network_monitor.last_accessed = Time.now

    if @network_monitor.save
      render json: 'okay', status: 200
    else
      render json: response, status: 500
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_network_monitor
    @network_monitor = NetworkMonitor.find(params[:id])

    if @network_monitor.nil?
      render json: 'not found', status: 404
    end

    if @network_monitor.token.id != @token.id
      Rails.logger.error 'BAD ID'
      Rails.logger.error "wanted #{@network_monitor.token.id}, got #{@token.id}"

      unauthorized_token!('network_monitor:refresh')
    end
  end
end
