require "rails_helper"

RSpec.describe BlocksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/blocks").to route_to("blocks#index")
    end

    it "routes to #new" do
      expect(:get => "/blocks/new").to route_to("blocks#new")
    end

    it "routes to #show" do
      expect(:get => "/blocks/1").to route_to("blocks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/blocks/1/edit").to route_to("blocks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/blocks").to route_to("blocks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/blocks/1").to route_to("blocks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/blocks/1").to route_to("blocks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/blocks/1").to route_to("blocks#destroy", :id => "1")
    end

  end
end
