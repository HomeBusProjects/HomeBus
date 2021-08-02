class Api::DevicesController < Api::ApplicationController
    before_action -> { api_authenticate!('provision_request:create') }, only: [ :create ]
    before_action -> { api_authenticate!('provision_request:manage') }, only: [ :show, :update, :destroy ]

    def index
      render json: { devices: @token.provision_request.devices }, status: 200
    end

    # GET /api/devices
    def show
      if params[:id] != @token.device_id
        Rails.logger.error 'BAD DEVICE ID'

        unauthorized_token!('device:manage') 
        return
      end

      device = Device.find params[:id]

      render json: {
               device: {
                 identity: {
                   manufacturer: device[:manufacturer],
                   model_number: device[:model_number],
                   serial_number: device[:serial_number],
                   
                 },
                 id: device[:id]
               } },
             status: 200
    end

    def create

      device_token = Token.create scope: 'device:manage', device: @device
    end

    # POST/PUT /api/devices
    def update
    end

    # DELETE /api/devices
    def destroy
      @token.device.destroy

      render json: "device destroyed", status: 200
    end

    private

    def params
    end
end
