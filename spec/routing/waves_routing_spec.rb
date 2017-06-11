require "rails_helper"

RSpec.describe WavesController, type: :routing do
  describe "routing" do


    it "routes to #new" do
      expect(:get => "/waves/new").to route_to("waves#new")
    end


    it "routes to #create" do
      expect(:post => "/waves").to route_to("waves#create")
    end

  end
end
