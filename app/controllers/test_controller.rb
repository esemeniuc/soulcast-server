class TestController < ApplicationController
  def index
  end

  def sendToEveryone
    Soul.last.sendToEveryone;
  end
end
