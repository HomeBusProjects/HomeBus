require 'securerandom'

class ProvisionRequestsController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_provision_request, only: [:show, :edit, :update, :destroy, :accept, :deny, :revoke]

  def accept
    @provision_request.accept!

    respond_to do |format|
      if @provision_request.save
        PublishDevicesJob.perform_later(@provision_request.network)

        flash_message 'success', 'Provision request was successfully accepted.'

        format.html { redirect_to @provision_request }
        format.json { render :show, status: :created, location: @provision_request }
      else
        format.html { render :new }
        format.json { render json: @provision_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def deny
    @provision_request.devices.update_all(provisioned: false)
    @provision_request.denied!

    @provision_request.mosquitto_account.enabled = false

    respond_to do |format|
      if @provision_request.save
        flash_message 'warning', 'Provision request was successfully denied.'

        format.html { redirect_to @provision_request }
        format.json { render :show, status: :created, location: @provision_request }
      else
        format.html { render :new }
        format.json { render json: @provision_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def revoke
    @provision_request.devices.update_all(provisioned: false)
    @provision_request.revoke

    respond_to do |format|
      if @provision_request.save
        flash_message 'danger', 'Provision request was successfully revoked.'

        format.html { redirect_to @provision_request }
        format.json { render :show, status: :created, location: @provision_request }
      else
        format.html { render :new }
        format.json { render json: @provision_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /provision_requests
  # GET /provision_requests.json
  def index
    if signed_in? && current_user.site_admin?
      @unanswered_provision_requests = ProvisionRequest.where(status: ProvisionRequest.statuses[:unanswered]).order(created_at: :desc)
      @provision_requests = ProvisionRequest.where('status != ?', ProvisionRequest.statuses[:unanswered]).order(friendly_name: :asc, created_at: :desc)
    else
      @unanswered_provision_requests = current_user.provision_requests.where(status: ProvisionRequest.statuses[:unanswered]).order(created_at: :desc)
      @provision_requests = current_user.provision_requests.where('status != ?', ProvisionRequest.statuses[:unanswered]).order(friendly_name: :asc, created_at: :desc)
    end

    if params[:q]
      query = params[:q]
      @unanswered_provision_requests = @unanswered_provision_requests.where("id::text ILIKE '%#{query}%' OR friendly_name ILIKE '%#{query}%' OR manufacturer ILIKE '%#{query}%' OR model ILIKE '%#{query}%' OR serial_number ILIKE '%#{query}%'")
      @provision_requests = @provision_requests.where("id::text ILIKE '%#{query}%' OR friendly_name ILIKE '%#{query}%' OR manufacturer ILIKE '%#{query}%' OR model ILIKE '%#{query}%' OR serial_number ILIKE '%#{query}%'")
    end

    @unanswered_provision_requests = @unanswered_provision_requests.order(friendly_name: :asc)
    @provision_requests = @provision_requests.order(friendly_name: :asc)
  end

  # GET /provision_requests/1
  # GET /provision_requests/1.json
  def show
  end

  # GET /provision_requests/new
  def new
    @provision_request = ProvisionRequest.new

    if signed_in? && current_user.site_admin?
      @users = User.all.order(email: :asc)
      @networks = Network.all.order(name: :asc)
    else
      @users = [ current_user ]
      @networks = current_user.networks.order(name: :asc)
    end
  end

  # GET /provision_requests/1/edit
  def edit
  end

  # POST /provision_requests
  # POST /provision_requests.json
  def create
    p = provision_request_params

    @provision_request = ProvisionRequest.new(p)
    @provision_request.ip_address = request.remote_ip
    @provision_request.user = current_user

    respond_to do |format|
      if @provision_request.save
        flash_message 'success', 'Provision request was successfully created.'

        format.html { redirect_to @provision_request }
        format.json { render :show, status: :created, location: @provision_request }
      else
        format.html { render :new }
        format.json { render json: @provision_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provision_requests/1
  # PATCH/PUT /provision_requests/1.json
  def update
    p = provision_request_params

    respond_to do |format|
      if @provision_request.update(p)
        PublishDevicesJob.perform_later(@provision_request.network)

        flash_message 'success', 'Provision request was successfully updated.'

        format.html { redirect_to @provision_request }
        format.json { render :show, status: :ok, location: @provision_request }
      else
        format.html { render :edit }
        format.json { render json: @provision_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provision_requests/1
  # DELETE /provision_requests/1.json
  def destroy
    @provision_request.destroy

    respond_to do |format|
      flash_message 'danger', 'Provision request was successfully destroyed.'

      format.html { redirect_to provision_requests_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provision_request
      @provision_request = ProvisionRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provision_request_params
      arrayize_ddcs!(params.require(:provision_request).permit(:pin, :friendly_name, :manufacturer, :model, :serial_number, :status, :wo_ddcs, :ro_ddcs, :rw_ddcs, :network_id, :uuids))
    end

    def arrayize_ddcs!(p)
      wo_ddcs = p[:wo_ddcs]
      if wo_ddcs.present?
        p.merge!({ wo_ddcs: wo_ddcs.split })
      end

      ro_ddcs = p[:ro_ddcs]
      if ro_ddcs.present?
        p.merge!({ ro_ddcs: ro_ddcs.split })
      end

      p
    end
end
