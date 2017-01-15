require "rails_helper"

RSpec.describe ImprovesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/improves").to route_to("improves#index")
    end

    it "routes to #new" do
      expect(:get => "/improves/new").to route_to("improves#new")
    end

    it "routes to #show" do
      expect(:get => "/improves/1").to route_to("improves#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/improves/1/edit").to route_to("improves#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/improves").to route_to("improves#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/improves/1").to route_to("improves#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/improves/1").to route_to("improves#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/improves/1").to route_to("improves#destroy", :id => "1")
    end

  end
end
