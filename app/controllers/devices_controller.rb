class DevicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    p = params.permit(:provision_id, :space_id)

    @devices = Device.all

    if p[:space_id]
      @devices = Space.find(p[:space_id]).devices
    end

    if p[:provision_id]
      @devices = @devices.where(provision_request_id: p[:provision_id])
    end

  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
       flash_message 'success', 'Device was successfully created.'

        format.html { redirect_to @device }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        flash_message 'success', 'Device was successfully updated.'

        format.html { redirect_to @device }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      flash_message 'danger', 'Device was successfully deleted.'

      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:provisioned, :friendly_name, :friendly_location, :index, :accuracy, :precision, :update_frequency, :calibrated, :provision_request_id, { wo_topics: [], ro_topics: [], rw_topics: [], space_ids: [] })
    end
end
