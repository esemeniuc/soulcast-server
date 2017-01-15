require "rails_helper"

RSpec.describe "API call", :type => :request do
  before(:each) do
      DatabaseCleaner.clean_with(:truncation, reset_ids: true)

      post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"token1" } }

      expect_id_token1 = JSON.parse(response.body)["id"]

      post "/devices.json", 
      params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"token2" } }  
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

  it "improves" do
    post "/improves.json",
        params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345,
        epoch:123456789,
        latitude:100,
        longitude:100,
        radius:20,
        token:"12345asdfgqwerty" } }
    expect(response).to have_http_status(201)
  end

  it "blocks" do
    post "/blocks.json",
      params: { 
        blocker_token: "token1", 
        blockee_token: "token2"
      }
    expect(response).to have_http_status(201)
    end

  xit "echo" do
    post "/echo.json",
        params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345,
        epoch:123456789,
        latitude:100,
        longitude:100,
        radius:20,
        token:"12345asdfgqwerty" } }
    expect_token = JSON.parse(response.body)["token"]
    expect(expect_token).to be "12345asdfgqwerty"
  end

  xit "returns the history of the device id" do
    get "/history/{expect_id_token1}.json",
    expect_token = JSON.parse(response.body)["token"]
    expect(expect_token).to_not "token1"
  end
end