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
    @token = @network.get_auth_token(current_user)

    @wo_ddcs = @network.provision_requests.pluck(:wo_ddcs).flatten.uniq.sort
    @ro_ddcs = @network.provision_requests.pluck(:ro_ddcs).flatten.uniq.sort
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

  # GET /networks/#/monitor
  def monitor
    @consume_ddcs = @network.provision_requests.pluck(:wo_ddcs).flatten.uniq.sort

    @endpoints = Permission.where(network: @network, publishes: true).map do |perm|
      "homebus/device/#{perm.device.id}/#{perm.ddc.name}"
    end
    @uuid_name_map = @network.devices.map { |device| { id: device[:id], name: device[:friendly_name] } }

    pr = ProvisionRequest.create manufacturer: 'Homebus',
                                 model: 'Temporary web monitor',
                                 serial_number: @network.id,
                                 ro_ddcs: @consume_ddcs,
                                 wo_ddcs: [],
                                 requested_uuid_count: 1,
                                 network: @network,
                                 ip_address: '127.0.0.1',
                                 friendly_name: 'Temporary web monitor',
                                 user: current_user,
                                 autoremove_interval: 9 * 60,
                                 autoremove_at: Time.zone.now + 9.minutes

    pr.accept!

    @broker = {}

    @broker[:server] = pr.network.broker.name
    @broker[:port] = 8083

    @broker[:username] = pr.account_id
    @broker[:password] = pr.account_password

    @client_id = pr.id
    @refresh_token = pr.get_refresh_token(current_user)
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
