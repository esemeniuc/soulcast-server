class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update] #for dev only, disables authenticity checking on create/update

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

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        #format.json { render json: @device.errors, status: :unprocessable_entity }

        jsonDevice = Device.find_by_token(@device.token)
        if jsonDevice.nil?
          render json: badRequest, status: :unprocessable_entity
          return
        end

        format.json { render json: Device.find_by_token(@device.token) } #return json of matching token rather than show error
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
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

  # GET /nearby/?latitude=49.3&longitude=-122.9&radius=0.1&token=SSSSSSSS
  def nearby
    if validParams?(params)
      render json: deviceCount(params)
    else
      render json: badRequest, status: :unprocessable_entity
    end
  end

  def badRequest
    {message: "bad request"}
  end

  def validParams?(params)
    return params[:latitude] && params[:longitude] && params[:radius] && params[:token] #check if we're getting extra params
  end

  def deviceCount(params)
    @device = Device.find_by_token(params[:token])
    @device.update(latitude: params[:latitude], longitude: params[:longitude], radius: params[:radius])
    {nearby: @device.nearbyDeviceCount}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:token, :latitude, :longitude, :radius, :os)
    end
end
