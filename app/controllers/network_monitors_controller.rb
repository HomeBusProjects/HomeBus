class NetworkMonitorsController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_network_monitor, only: %i[ show edit update destroy ]

  # GET /network_monitors or /network_monitors.json
  def index
    @network_monitors = NetworkMonitor.all
  end

  # GET /network_monitors/1 or /network_monitors/1.json
  def show
    @network = @network_monitor.provision_request.network
    @consumes = @network.provision_requests.pluck(:consumes).flatten.uniq.sort

    @uuid_name_map = @network.devices.map { |device| { id: device[:id], name: device[:friendly_name] } }

    @broker = {}

    @broker[:server] = @network_monitor.provision_request.network.broker.name
    @broker[:port] = 8083

    @broker[:username] = @network_monitor.provision_request.broker_account.id
    @broker[:password] = @network_monitor.provision_request.broker_account.enc_password
  end

  # GET /network_monitors/new
  def new
    @network_monitor = NetworkMonitor.new
  end

  # GET /network_monitors/1/edit
  def edit
  end

  # POST /network_monitors or /network_monitors.json
  def create
    @network = Network.find network_monitor_params[:id]
    consumes = @network.provision_requests.pluck(:consumes).flatten.uniq.sort

    pr = ProvisionRequest.create(
                                 consumes: consumes,
                                 publishes: [],
                                 network: @network,
                                 friendly_name: 'Temporary web monitor',
                                 ip_address: '127.0.0.1',
                                 user: current_user
    )
    pr.accept!
   
    @network_monitor = NetworkMonitor.create(user: current_user,
                                             provision_request: pr,
                                             last_accessed: Time.now)

    Device.create  manufacturer: 'Homebus',
                   model: 'Temporary web monitor',
                   serial_number: @network_monitor.id,
                   provision_request: pr

    respond_to do |format|
      if @network_monitor.save
        format.html { redirect_to @network_monitor, notice: "Network monitor was successfully created." }
        format.json { render :show, status: :created, location: @network_monitor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @network_monitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /network_monitors/1 or /network_monitors/1.json
  def update
    respond_to do |format|
      if @network_monitor.update(network_monitor_params)
        format.html { redirect_to @network_monitor, notice: "Network monitor was successfully updated." }
        format.json { render :show, status: :ok, location: @network_monitor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @network_monitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /network_monitors/1 or /network_monitors/1.json
  def destroy
    @network_monitor.destroy
    respond_to do |format|
      format.html { redirect_to network_monitors_url, notice: "Network monitor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_network_monitor
      @network_monitor = NetworkMonitor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def network_monitor_params
      params.require(:network).permit(:id)
    end
end
