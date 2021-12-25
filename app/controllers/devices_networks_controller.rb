class DevicesNetworksController < ApplicationController
  before_action :set_devices_network, only: %i[ show edit update destroy ]

  # POST /devices_networks or /devices_networks.json
  def create
    @devices_network = DevicesNetwork.new(devices_network_params)

    respond_to do |format|
      if @devices_network.save
        format.html { redirect_to request.referer, notice: "Devices network was successfully created." }
        format.json { render :show, status: :created, location: @devices_network }
      else
        format.html { redirect_to request.referer, notice: 'Cannot be added' }
        format.json { render json: @devices_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices_networks/1 or /devices_networks/1.json
  def destroy
    @devices_network.destroy

    respond_to do |format|
      format.html { redirect_to request.referer, notice: "Device was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
    def devices_network_params
      params.require(:devices_networks).permit(:device_id, :network_id)
    end
end
