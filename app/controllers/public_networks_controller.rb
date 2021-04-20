class PublicNetworksController < ApplicationController
  before_action :set_public_network, only: %i[ show edit update destroy ]

  # GET /public_networks or /public_networks.json
  def index
    @public_networks = PublicNetwork.all
  end

  # GET /public_networks/1 or /public_networks/1.json
  def show
  end

  # GET /public_networks/new
  def new
    @public_network = PublicNetwork.new
  end

  # GET /public_networks/1/edit
  def edit
  end

  # POST /public_networks or /public_networks.json
  def create
    @public_network = PublicNetwork.new(public_network_params)

    respond_to do |format|
      if @public_network.save
        format.html { redirect_to @public_network, notice: "Public network was successfully created." }
        format.json { render :show, status: :created, location: @public_network }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @public_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /public_networks/1 or /public_networks/1.json
  def update
    respond_to do |format|
      if @public_network.update(public_network_params)
        format.html { redirect_to @public_network, notice: "Public network was successfully updated." }
        format.json { render :show, status: :ok, location: @public_network }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @public_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /public_networks/1 or /public_networks/1.json
  def destroy
    @public_network.destroy
    respond_to do |format|
      format.html { redirect_to public_networks_url, notice: "Public network was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_public_network
      @public_network = PublicNetwork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def public_network_params
      params.require(:public_network).permit(:title, :description, :network_id, :active)
    end
end
