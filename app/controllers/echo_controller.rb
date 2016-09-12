class EchoController < ApplicationController
  skip_before_action :verify_authenticity_token #for dev only, disables authenticity checking

  def reply
    render :json => params[:echo]
  end
end
