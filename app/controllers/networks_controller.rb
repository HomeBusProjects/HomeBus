class NetworksController < ApplicationController
  before_action :set_network, only: [:show, :edit, :update, :destroy, :monitor]

  # GET /networks
  # GET /networks.json
  def index
    if can? :manage, :devices
      @networks = Network.all
    else
      @networks = @current_user.networks
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
  def edit
  end

  # POST /networks
  # POST /networks.json
  def create
    @network = Network.new(network_params.merge({ broker: Broker.first}))

    pp @network

    respond_to do |format|
      if @network.save
        @network.users << current_user

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
    pp 'DDCS', @consume_ddcs

    pr = ProvisionRequest.create manufacturer: 'Homebus',
                                 model: 'Temporary web monitor',
                                 serial_number: @network.id,
                                 ro_ddcs: @consume_ddcs,
                                 wo_ddcs: [],
                                 requested_uuid_count: 1,
                                 network: @network,
                                 ip_address: '127.0.0.1'

    pr.accept!

    @broker = Hash.new

    @broker[:server] = pr.network.broker.name
    @broker[:port] = 8883

    @broker[:username] = pr.mosquitto_account.id
    @broker[:password] = pr.mosquitto_account.generate_password!

    @client_id = pr.id
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_network
      @network = Network.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def network_params
      params.require(:network).permit(:name, :count_of_users, :token)
    end
end
