class ImprovesController < ApplicationController
  before_action :set_improve, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update] #for dev only, disables authenticity checking on create/update
  
  # GET /improves
  # GET /improves.json
  def index
    @improves = Improve.all
  end

  # GET /improves/1
  # GET /improves/1.json
  def show
  end

  # GET /improves/new
  def new
    @improve = Improve.new
  end

  # GET /improves/1/edit
  def edit
  end

  # POST /improves
  # POST /improves.json
  def create
    @improve = Improve.new(improve_params)

    respond_to do |format|
      if @improve.save
        format.html { redirect_to @improve, notice: 'Improve was successfully created.' }
        format.json { render :show, status: :created, location: @improve }
      else
        format.html { render :new }
        format.json { render json: @improve.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /improves/1
  # PATCH/PUT /improves/1.json
  def update
    respond_to do |format|
      if @improve.update(improve_params)
        format.html { redirect_to @improve, notice: 'Improve was successfully updated.' }
        format.json { render :show, status: :ok, location: @improve }
      else
        format.html { render :edit }
        format.json { render json: @improve.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /improves/1
  # DELETE /improves/1.json
  def destroy
    @improve.destroy
    respond_to do |format|
      format.html { redirect_to improves_url, notice: 'Improve was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_improve
      @improve = Improve.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def improve_params
      params.require(:improve).permit(:soulType, :s3Key, :epoch, :latitude, :longitude, :radius)
    end
end
