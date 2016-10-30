class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update] #for dev only, disables authenticity checking on create

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)
    @device.simulator #hax for june's simulator
    if @device.valid? == false
      puts "NOTVALID NOTVALID NOTVALID NOTVALID NOTVALID NOTVALID NOTVALID NOTVALID" #probably because we have a duplicate
      head :bad_request
      return
    end

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        # format.json { render json: @device.errors, status: :unprocessable_entity }
        format.json { render json: Device.find_by_token(@device.token) } #return json of matching token rather than show error
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    @device.simulator #hax for june's simulator

    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /nearby/SOME_ID_HERE.json
  # GET /nearby/SOME_USELESS_ID_HERE.json?latitude=49.3&longitude=-122.9&radius=0.1
  def nearby
    if params[:latitude] && params[:longitude] && params[:radius] #check if we're getting no extra params
      #make temp device with random token
      @device = Device.new(token: SecureRandom.hex, latitude: params[:latitude], longitude: params[:longitude], radius: params[:radius])
    else
      set_device
    end

    jsonReturn = {nearby: @device.nearbyDeviceCount}
    render json: jsonReturn
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      # params.permit(:token, :longitude, :latitude, :radius, :arn) #hack for json double nesting, breaks edit page functionality
      params.require(:device).permit(:token, :longitude, :latitude, :radius, :arn)
    end
end
