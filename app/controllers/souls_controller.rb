class SoulsController < ApplicationController
  before_action :set_soul, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create] #for dev only, disables authenticity checking on create

  # GET /souls
  # GET /souls.json
  def index
    @souls = Soul.all
  end

  # GET /souls/1
  # GET /souls/1.json
  def show
  end

  # GET /souls/new
  def new
    @soul = Soul.new
  end

  # GET /souls/1/edit
  def edit
  end

  # POST /souls
  # POST /souls.json
  def create
    @soul = Soul.new(soul_params)
	deviceID = Device.where(token: @soul.token)
	@soul.device_id = deviceID.id

    respond_to do |format|
      if @soul.save
        format.html { redirect_to @soul, notice: 'Soul was successfully created.' }
        format.json { render :show, status: :created, location: @soul }
      else
        format.html { render :new }
        format.json { render json: @soul.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /souls/1
  # PATCH/PUT /souls/1.json
  def update
    respond_to do |format|
      if @soul.update(soul_params)
        format.html { redirect_to @soul, notice: 'Soul was successfully updated.' }
        format.json { render :show, status: :ok, location: @soul }
      else
        format.html { render :edit }
        format.json { render json: @soul.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /souls/1
  # DELETE /souls/1.json
  def destroy
    @soul.destroy
    respond_to do |format|
      format.html { redirect_to souls_url, notice: 'Soul was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_soul
      @soul = Soul.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def soul_params
      params.require(:soul).permit(:soulType, :s3Key, :epoch, :longitude, :latitude, :radius, :token)
      #### note the lack of :device_id as well (we dont need it)
    end
end
