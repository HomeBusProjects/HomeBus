require 'securerandom'

class ProvisionRequestsController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_provision_request, only: [:show, :edit, :update, :destroy, :accept, :deny, :revoke]

  def accept
    i = 0

    @provision_request.requested_uuid_count.times do
      device = @provision_request.devices.create friendly_name: "#{@provision_request.friendly_name}-#{i}"
      i += 1
    end

    @provision_request.accepted!
    @provision_request.create_mosquitto_account(superuser: true, password: SecureRandom.base64(32), enabled: true)

    respond_to do |format|
      if @provision_request.save
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
    @provision_request.revoked!

    @provision_request.mosquitto_account.enabled = false

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
    if can? :manage, ProvisionRequest
      @unanswered_provision_requests = ProvisionRequest.where(status: ProvisionRequest.statuses[:unanswered]).order(created_at: :desc)
      @provision_requests = ProvisionRequest.where('status != ?', ProvisionRequest.statuses[:unanswered]).order(friendly_name: :asc, created_at: :desc)
    else
      @unanswered_provision_requests = current_user.provision_requests.where(status: ProvisionRequest.statuses[:unanswered]).order(created_at: :desc)
      @provision_requests = current_user.provision_requests.where('status != ?', ProvisionRequest.statuses[:unanswered]).order(friendly_name: :asc, created_at: :desc)
    end

    if params[:q]
      query = params[:q]
      @provision_requests = @provision_requests.where("id::text ILIKE '%#{query}%' OR friendly_name ILIKE '%#{query}%' OR manufacturer ILIKE '%#{query}%' OR model ILIKE '%#{query}%' OR serial_number ILIKE '%#{query}%'")
    end
  end

  # GET /provision_requests/1
  # GET /provision_requests/1.json
  def show
  end

  # GET /provision_requests/new
  def new
    @provision_request = ProvisionRequest.new
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
    if @provision_request.mosquitto_account
      @provision_request.mosquitto_account.delete
    end

    @provision_request.mosquitto_acl.delete_all
    @provision_request.devices.delete_all

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
      arrayize_ddcs!(params.require(:provision_request).permit(:pin, :friendly_name, :manufacturer, :model, :serial_number, :status, :wo_ddcs, :ro_ddcs, :rw_ddcs, :uuids))
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
