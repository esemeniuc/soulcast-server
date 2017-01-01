require "rails_helper"

RSpec.describe "API management", :type => :request do

  it "creates a new device" do
    post "/devices"
    expect(response).to render_template(:new)

    post "/widgets", :widget => {:name => "My Widget"}

    expect(response).to redirect_to(assigns(:widget))
    follow_redirect!

    expect(response).to render_template(:show)
    expect(response.body).to include("Widget was successfully created.")
  end

  it "updates device location" do
    patch "/devices/{id}"
    expect(response).to_not render_template(:show)
  end

  it "creates new soul" do
    post "/souls"
    expect(response).to_not render_template(:show)
  end

  it "get nearby devices" do
    get "/nearby"
    expect(response).to_not render_template(:show)
  end

  it "improves" do
    post "/improves"
    expect(response).to_not render_template(:show)
  end

  it "blocks" do
    post "/blocks"
    expect(response).to_not render_template(:show)
  end

  it "echo" do
    post "/echo"
    expect(response).to_not render_template(:show)
  end

  it "returns the history of the device id" do
    get "/history/{id}"
    expect(response).to_not render_template(:show)
  end
end