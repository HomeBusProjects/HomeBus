# frozen_string_literal: true

class PublicDevicesController < ApplicationController
  before_action :set_public_device, only: %i[show edit update destroy]

  # GET /public_devices or /public_devices.json
  def index
    @public_devices = PublicDevice.all
  end

  # GET /public_devices/1 or /public_devices/1.json
  def show; end

  # GET /public_devices/new
  def new
    @public_device = PublicDevice.new
  end

  # GET /public_devices/1/edit
  def edit; end

  # POST /public_devices or /public_devices.json
  def create
    @public_device = PublicDevice.new(public_device_params)

    respond_to do |format|
      if @public_device.save
        format.html { redirect_to @public_device, notice: 'Public device was successfully created.' }
        format.json { render :show, status: :created, location: @public_device }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @public_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /public_devices/1 or /public_devices/1.json
  def update
    respond_to do |format|
      if @public_device.update(public_device_params)
        format.html { redirect_to @public_device, notice: 'Public device was successfully updated.' }
        format.json { render :show, status: :ok, location: @public_device }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @public_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /public_devices/1 or /public_devices/1.json
  def destroy
    @public_device.destroy
    respond_to do |format|
      format.html { redirect_to public_devices_url, notice: 'Public device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_public_device
    @public_device = PublicDevice.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def public_device_params
    params.require(:public_device).permit(:title, :description, :device_id, :active)
  end
end
