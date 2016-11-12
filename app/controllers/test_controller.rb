class TestController < ApplicationController
  def index
  end

  def sendToEveryone
    Soul.first.sendToEveryone;
  end
end
