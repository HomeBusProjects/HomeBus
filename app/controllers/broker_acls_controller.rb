# frozen_string_literal: true

class BrokerAclsController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_broker_acl, only: %i[show edit update destroy]

  # GET /broker_acls
  # GET /broker_acls.json
  def index
    @broker_acls = BrokerAcl.all
  end

  # GET /broker_acls/1
  # GET /broker_acls/1.json
  def show; end

  # GET /broker_acls/new
  def new
    @broker_acl = BrokerAcl.new
  end

  # GET /broker_acls/1/edit
  def edit; end

  # POST /broker_acls
  # POST /broker_acls.json
  def create
    @broker_acl = BrokerAcl.new(broker_acl_params)
    @broker_acl.username = @broker_acl.provision_request.broker_account.id

    respond_to do |format|
      if @broker_acl.save
        flash_message 'success', 'Broker acl was successfully created.'

        format.html { redirect_to @broker_acl }
        format.json { render :show, status: :created, location: @broker_acl }
      else
        format.html { render :new }
        format.json { render json: @broker_acl.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /broker_acls/1
  # PATCH/PUT /broker_acls/1.json
  def update
    p = broker_acl_params
    p.delete :provision_request_id
    p.delete :username

    respond_to do |format|
      if @broker_acl.update(p)
        flash_message 'success', 'Broker acl was successfully updated.'

        format.html { redirect_to @broker_acl }
        format.json { render :show, status: :ok, location: @broker_acl }
      else
        format.html { render :edit }
        format.json { render json: @broker_acl.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /broker_acls/1
  # DELETE /broker_acls/1.json
  def destroy
    @broker_acl.destroy
    respond_to do |format|
      flash_message 'danger', 'Broker acl was successfully destroyed.'

      format.html { redirect_to broker_acls_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_broker_acl
    @broker_acl = BrokerAcl.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def broker_acl_params
    params.require(:broker_acl).permit(:topic, :permissions, :read, :write, :subscribe, :provision_request)
  end
end
