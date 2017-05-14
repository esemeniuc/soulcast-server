require "rails_helper"

RSpec.describe "API call", :type => :request do
  before(:each) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
    @deviceParams1 = {device: {
        latitude:100,
        longitude:100,
        radius:20,
        token:"AAAAAAAA",
        os: "ios" }}

    @deviceParams2 = {device: {
        latitude:100,
        longitude:105,
        radius:20,
        token:"BBBBBBBB",
        os: "ios" }}

    @deviceParams3 = {device: {
        latitude:100,
        longitude:110,
        radius:20,
        token:"CCCCCCCC",
        os: "ios" }}

    @soulParams1 = { soul: {
        soulType: "RSpecTestSoul",
        s3Key: 12345,
        epoch:123456789,
        latitude:100,
        longitude:100,
        radius:20,
        token:"AAAAAAAA" }}
  end

  it "creates a new device" do
    post "/devices.json", params: @deviceParams1
    expect(response).to have_http_status(201) 
  end

  it "doesn't create a new device without a device token" do
    tempDeviceParams = @deviceParams1
    tempDeviceParams[:device].delete(:token)

    post "/devices.json", params: tempDeviceParams
    expect(response).to have_http_status(422)
  end

  it "updates device location" do
    post "/devices.json", params: @deviceParams1
    device_id = JSON.parse(response.body)["id"]
    patch "/devices/#{device_id}.json", params: @deviceParams2
    expect(response).to have_http_status(200)
  end

  it "creates new soul" do
    post "/devices.json", params: @deviceParams1
    post "/souls.json", params: @soulParams1
    expect(response).to have_http_status(201)
  end

  it "doesn't create a soul without an s3 key" do
    tempSoulParams = @soulParams1
    tempSoulParams[:soul].delete(:s3Key)
    post "/souls.json", params: tempSoulParams
    expect(response).to have_http_status(422)
  end

  it "gets nearby devices" do
    post "/devices.json", params: @deviceParams1
    post "/devices.json", params: @deviceParams2
    post "/devices.json", params: @deviceParams3

    get "/nearby", params: { latitude: @deviceParams1[:device][:latitude],
                             longitude: @deviceParams1[:device][:longitude],
                             radius: @deviceParams1[:device][:radius],
                             token: @deviceParams1[:device][:token] }

    nearby_count = JSON.parse(response.body)["nearby"]
    
    expect(nearby_count).to be 2
  end

  it "improves" do
    post "/devices.json", params: @deviceParams1

    post "/improves.json",
        params: { improve: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345,
        epoch:123456789,
        latitude:100,
        longitude:100,
        radius:20,
        token:"AAAAAAAA" } }
    expect(response).to have_http_status(201)
  end

  it "blocks" do
    post "/devices.json", params: @deviceParams1
    post "/devices.json", params: @deviceParams2

    post "/blocks.json",
      params: { block: {
        blocker_token: "AAAAAAAA",
        blockee_token: "BBBBBBBB"
      } }
    expect(response).to have_http_status(201)
  end

  xit "echo" do
    post "/echo.json", @deviceParams1
    expect_token = JSON.parse(response.body)["token"]
    expect(expect_token).to be "AAAAAAAA"
  end

  context "a blocks b, b sends out a soul" do
    it "should not have b's soul in a's history or call node" do
      post "/devices.json", params: @deviceParams1

      dev1id = JSON.parse(response.body)["id"]
      post "/devices.json", params: @deviceParams2

      post "/blocks.json",
        params: { block: {
          blocker_token: "AAAAAAAA",
          blockee_token: "BBBBBBBB"
        } }


      post "/souls.json", params: @soulParams1

      get "/device_history/#{dev1id}.json"
      soulHistoryArray = JSON.parse(response.body)
      expect(soulHistoryArray.size).to be 0
    end
  end
end