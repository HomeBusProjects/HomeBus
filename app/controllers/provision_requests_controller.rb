class ProvisionRequestsController < ApplicationController
  before_action :set_provision_request, only: [:show, :edit, :update, :destroy, :accept, :deny, :revoke]

  def accept
    @provision_request.devices.update_all(provisioned: true)
    @provision_request.accepted!

    respond_to do |format|
      if @provision_request.save
        format.html { redirect_to @provision_request, notice: 'Provision request was successfully accepted.' }
        format.json { render :show, status: :created, location: @provision_request }
      else
        format.html { render :new }
        format.json { render json: @provision_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def deny
    @provision_request.devices.update_all(provisioned: false)
    @provision_request.dened!

    respond_to do |format|
      if @provision_request.save
        format.html { redirect_to @provision_request, notice: 'Provision request was successfully denied.' }
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

    respond_to do |format|
      if @provision_request.save
        format.html { redirect_to @provision_request, notice: 'Provision request was successfully revoked.' }
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
    @provision_requests = ProvisionRequest.all
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
    @provision_request = ProvisionRequest.new(args)

    respond_to do |format|
      if @provision_request.save
        format.html { redirect_to @provision_request, notice: 'Provision request was successfully created.' }
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
    respond_to do |format|
      if @provision_request.update(provision_request_params)
        format.html { redirect_to @provision_request, notice: 'Provision request was successfully updated.' }
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
      format.html { redirect_to provision_requests_url, notice: 'Provision request was successfully destroyed.' }
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
      params.require(:provision).permit(:pin, :ip_adress, :wo_topics, :ro_topics, :rw_topics, :status)
    end
end
