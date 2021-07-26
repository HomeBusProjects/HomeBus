class Api::DevicesController < Api::ApplicationController
    before_action :api_authenticate!

    def index
      render json: { devices: @token.provision_request.devices }, status: 200
    end

    # GET /api/devices
    def show
      device = @token.device
      render json: {
               device: {
                 identity: {
                   manufacturer: device[:manufacturer],
                   model_number: device[:model_number],
                   serial_number: device[:serial_number],
                   
                 },
                 uuid: device[:id]
               } },
             status: 200
    end

    def create
      @token
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
