class NearbyController < ApplicationController

  # GET /nearby/SOME_ID_HERE.json
  def fetch
    randInt = Random.new
    jsonReturn = {nearby: randInt.rand(20)}
    render :json => jsonReturn
  end
end
