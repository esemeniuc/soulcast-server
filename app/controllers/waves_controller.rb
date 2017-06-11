class WavesController < ApplicationController
  def new
    @wave = Wave.new
  end

  # POST /waves
  # POST /waves.json
  def create
    @wave = Wave.new(wave_params)
    respond_to do |format|
      if @wave.valid?
        @wave.echoBackWave()

      else

        format.html { render :new }

      end
    end
  end


  private
  def wave_params
    params.require(:wave).permit(:castVoice, :callVoice, :replyVoice, :casterToken, :callerToken,:type, :epoch)
  end
end
