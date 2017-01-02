require "rails_helper"

RSpec.describe "API call", :type => :request do

  xit "creates a new device" do
    post "/devices"
    expect(response).to render_template(:new)

    post "/widgets", :widget => {:name => "My Widget"}

    expect(response).to redirect_to(assigns(:widget))
    follow_redirect!

    expect(response).to render_template(:show)
    expect(response.body).to include("Widget was successfully created.")
  end

  xit "updates device location" do
    patch "/devices/{id}"
    expect(response).to_not render_template(:show)
  end

  it "creates new soul" do
    post "/souls", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345, epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"12345asdfg" } }
    expect(response).to have_http_status(200)
  end

  it "doesn't create a soul without an s3 key" do
    post "/souls", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"12345asdfg" } }
    expect(response).to have_http_status(422)
  end

  xit "gets nearby devices" do
    get "/nearby"
    expect(response).to_not render_template(:show)
  end

  xit "improves" do
    post "/improves"
    expect(response).to_not render_template(:show)
  end

  xit "blocks" do
    post "/blocks"
    expect(response).to_not render_template(:show)
  end

  xit "echo" do
    post "/echo"
    expect(response).to_not render_template(:show)
  end

  xit "returns the history of the device id" do
    get "/history/{id}"
    expect(response).to_not render_template(:show)
  end
end