# frozen_string_literal: true

class BrokersController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_broker, only: %i[show edit update destroy]

  # GET /brokers
  # GET /brokers.json
  def index
    @brokers = Broker.all
  end

  # GET /brokers/1
  # GET /brokers/1.json
  def show; end

  # GET /brokers/new
  def new
    @broker = Broker.new
  end

  # GET /brokers/1/edit
  def edit; end

  # POST /brokers
  # POST /brokers.json
  def create
    @broker = Broker.new(broker_params)

    respond_to do |format|
      if @broker.save
        format.html { redirect_to @broker, notice: 'Broker was successfully created.' }
        format.json { render :show, status: :created, location: @broker }
      else
        format.html { render :new }
        format.json { render json: @broker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brokers/1
  # PATCH/PUT /brokers/1.json
  def update
    respond_to do |format|
      if @broker.update(broker_params)
        format.html { redirect_to @broker, notice: 'Broker was successfully updated.' }
        format.json { render :show, status: :ok, location: @broker }
      else
        format.html { render :edit }
        format.json { render json: @broker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brokers/1
  # DELETE /brokers/1.json
  def destroy
    @broker.destroy
    respond_to do |format|
      format.html { redirect_to brokers_url, notice: 'Broker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_broker
    @broker = Broker.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def broker_params
    params.require(:broker).permit(:name, :secure_port, :insecure_port)
  end
end
