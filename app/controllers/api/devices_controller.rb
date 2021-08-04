class Api::DevicesController < Api::ApplicationController
    before_action -> { api_authenticate!('device:create') }, only: [ :create ]
    before_action -> { api_authenticate!('device:manage') }, only: [ :index, :show, :update, :destroy ]

    before_action :set_device, only: [ :index, :show, :update, :destroy ]

    def index
      render json: { devices: @token.provision_request.devices.map { |d| device_json(d) } }, status: 200
    end

    # GET /api/devices
    def show
      render json: device_json(@device), status: 200
    end

    def create
      p = device_params

      @device = Device.new provision_request: ProvisionRequest.find(p[:provision_request_id]),
                           friendly_name: p[:name],
                           manufacturer: p[:identity][:manufacturer],
                           model: p[:identity][:model],
                           serial_number: p[:identity][:serial_number],
                           pin: p[:identity][:pin]

      if @provision_request.update(p)
        @device[:token] = Token.create scope: 'device:manage', device: @device

        PublishDevicesJob.perform_later(@device.network)

        render json: @device, status: 200
      end
    end

    # POST/PUT /api/devices
    def update
      p = device_params

      if @device.update(p)
        render json: device_json(@device), status: 200
      end
    end

    # DELETE /api/devices
    def destroy
      @device.destroy

      render json: "device destroyed", status: 200
    end

    private

    def set_device
      if @token.device_id != params[:id]
        Rails.logger.error 'BAD ID'

        unauthorized_token!('device:manage') 
      end

      @device = Device.find(params[:id])

      if @device.nil?
        render json: 'not found', status: 404
      end
    end

    def device_params
      params.require(:device).permit(:friendly_name, :provision_request_id, { identity: [ :manufacturer, :model, :serial_number, :pin ] })
    end

    def device_json(d)
      {
        device: {
          id: d[:id],
          identity: {
            manufacturer: d[:manufacturer],
            model_number: d[:model_number],
            serial_number: d[:serial_number],
            pin: d[:pin]
          }
        }
      }
    end
end
