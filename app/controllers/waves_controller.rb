class WavesController < ApplicationController
  def new
    @wave = Wave.new
  end

  # POST /waves
  # POST /waves.json
  def create
    binding.pry
    @wave = Wave.new(wave_params)
    # make a wave object,
    # return wave object
    respond_to do |format|
      if wave.valid?


        logger.debug "wave was created"

      else

        logger.debug "Error: wave not created"

      end
    end

  end

  private
  def wave_params
    params.require(:wave).permit(:castVoice, :callVoice, :replyVoice, :casterToken, :callerToken,:type, :epoch)
  end
end
