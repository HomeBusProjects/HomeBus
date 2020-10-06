class DdcsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ddc, only: [:show, :edit, :update, :destroy]

  # GET /ddcs
  # GET /ddcs.json
  def index
    @ddcs = Ddc.all.order(name: :asc)
  end

  # GET /ddcs/1
  # GET /ddcs/1.json
  def show
  end

  # GET /ddcs/new
  def new
    @ddc = Ddc.new
  end

  # GET /ddcs/1/edit
  def edit
  end

  # POST /ddcs
  # POST /ddcs.json
  def create
    @ddc = Ddc.new(ddc_params)

    respond_to do |format|
      if @ddc.save
        format.html { redirect_to @ddc, notice: 'Ddc was successfully created.' }
        format.json { render :show, status: :created, location: @ddc }
      else
        format.html { render :new }
        format.json { render json: @ddc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ddcs/1
  # PATCH/PUT /ddcs/1.json
  def update
    respond_to do |format|
      if @ddc.update(ddc_params)
        format.html { redirect_to @ddc, notice: 'Ddc was successfully updated.' }
        format.json { render :show, status: :ok, location: @ddc }
      else
        format.html { render :edit }
        format.json { render json: @ddc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ddcs/1
  # DELETE /ddcs/1.json
  def destroy
    @ddc.destroy
    respond_to do |format|
      format.html { redirect_to ddcs_url, notice: 'Ddc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ddc
      @ddc = Ddc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ddc_params
      params.require(:ddc).permit(:name, :description, :reference_url)
    end
end
