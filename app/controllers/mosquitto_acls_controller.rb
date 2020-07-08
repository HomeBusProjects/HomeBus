class MosquittoAclsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mosquitto_acl, only: [:show, :edit, :update, :destroy]

  # GET /mosquitto_acls
  # GET /mosquitto_acls.json
  def index
    @mosquitto_acls = MosquittoAcl.all
  end

  # GET /mosquitto_acls/1
  # GET /mosquitto_acls/1.json
  def show
  end

  # GET /mosquitto_acls/new
  def new
    @mosquitto_acl = MosquittoAcl.new
  end

  # GET /mosquitto_acls/1/edit
  def edit
  end

  # POST /mosquitto_acls
  # POST /mosquitto_acls.json
  def create
    @mosquitto_acl = MosquittoAcl.new(mosquitto_acl_params)

    respond_to do |format|
      if @mosquitto_acl.save
        flash_message 'success', 'Mosquitto acl was successfully created.'

        format.html { redirect_to @mosquitto_acl }
        format.json { render :show, status: :created, location: @mosquitto_acl }
      else
        format.html { render :new }
        format.json { render json: @mosquitto_acl.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mosquitto_acls/1
  # PATCH/PUT /mosquitto_acls/1.json
  def update
    p = mosquitto_acl_params
    p.delete :provision_request_id
    p.delete :username

    pp p
    respond_to do |format|
      if @mosquitto_acl.update(p)
        flash_message 'success', 'Mosquitto acl was successfully updated.'

        format.html { redirect_to @mosquitto_acl }
        format.json { render :show, status: :ok, location: @mosquitto_acl }
      else
        format.html { render :edit }
        format.json { render json: @mosquitto_acl.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mosquitto_acls/1
  # DELETE /mosquitto_acls/1.json
  def destroy
    @mosquitto_acl.destroy
    respond_to do |format|
      flash_message 'danger', 'Mosquitto acl was successfully destroyed.'

      format.html { redirect_to mosquitto_acls_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mosquitto_acl
      @mosquitto_acl = MosquittoAcl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mosquitto_acl_params
      params.require(:mosquitto_acl).permit(:username, :topic, :rw, :provision_request)
    end
end
