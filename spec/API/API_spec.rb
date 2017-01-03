require "rails_helper"

RSpec.describe "API call", :type => :request do
  before(:each) do
      DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end
  it "creates a new device" do
    post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"12345asdfgqwerty" } }
    expect(response).to have_http_status(201) 
  end

  it "doesn't create a new device without a device token" do
    post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20 } 
      }
    expect(response).to have_http_status(422)
  end

  it "updates device location" do
    post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"12345asdfgqwerty" } }

    device_id = JSON.parse(response.body)["id"]
    patch "/devices/#{device_id}.json",
      params: { device: { latitude: 10,
                          longitude: 10,
                          radius: 10,
                          token: "12345asdfgqwerty"
                        } }
    expect(response).to have_http_status(200)
  end

  it "creates new soul" do
    post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"12345asdfgqwerty" } }
    post "/souls.json", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345, epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"12345asdfgqwerty" } }
    expect(response).to have_http_status(201)
  end

  it "doesn't create a soul without an s3 key" do
    post "/souls.json", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"12345asdfg" } }
    expect(response).to have_http_status(422)
  end

  it "gets nearby devices" do
    post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"AAAAAAAA" } }
    post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:105, 
        radius:20, 
        token:"BBBBBBBB" } }
    post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:110, 
        radius:20, 
        token:"CCCCCCCC" } }

    get "/nearby", params: { latitude:100, 
                             longitude:100, 
                             radius:20, 
                             token:"AAAAAAAA" }
    # binding.pry
    nearby_count = JSON.parse(response.body)["nearby"]
    
    expect(nearby_count).to be 2
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