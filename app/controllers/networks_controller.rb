# frozen_string_literal: true

class NetworksController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_network, only: %i[show edit update destroy monitor]

  # GET /networks
  # GET /networks.json
  def index
    @networks = if can? :manage, :devices
                  Network.all
                else
                  @current_user.networks
                end
  end

  # GET /networks/1
  # GET /networks/1.json
  def show
    @publishes = @network.provision_requests.pluck(:publishes).flatten.uniq.sort
    @consumes = @network.provision_requests.pluck(:consumes).flatten.uniq.sort
  end

  # GET /networks/new
  def new
    @network = Network.new
  end

  # GET /networks/1/edit
  def edit; end

  # POST /networks
  # POST /networks.json
  def create
    @network = Network.new(network_params.merge({ broker: Broker.first }))

    respond_to do |format|
      if @network.save
        @network.users << current_user
        @network.create_homebus_announcer(current_user)

        format.html { redirect_to @network, notice: 'Network was successfully created.' }
        format.json { render :show, status: :created, location: @network }
      else
        format.html { render :new }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /networks/1
  # PATCH/PUT /networks/1.json
  def update
    respond_to do |format|
      if @network.update(network_params)
        PublishDevicesJob.perform_later(@network) if network_params[:name]

        format.html { redirect_to @network, notice: 'Network was successfully updated.' }
        format.json { render :show, status: :ok, location: @network }
      else
        format.html { render :edit }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.json
  def destroy
    @network.destroy
    respond_to do |format|
      format.html { redirect_to networks_url, notice: 'Network was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_network
    @network = Network.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def network_params
    params.require(:network).permit(:name, :count_of_users)
  end
end
