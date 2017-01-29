require "rails_helper"

RSpec.describe "Acceptance Test", :type => :request do
  before(:each) do
      DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end

  context 'cast soul Acceptance test' do
    before(:each) do
    post "/devices.json", 
        params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"12345asdfgqwerty" } }
    end

    it "registers device" do
      expect(response).to have_http_status(201)
      expect_token = JSON.parse(response.body)["token"]
    end

    it "receives id" do
      device_id = JSON.parse(response.body)["id"]
      expect(device_id).to be 1
    end

    it "sends soul and receives confirmation" do
      post "/souls.json", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345, epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"12345asdfgqwerty" } }
      expect(response).to have_http_status(201)
    end
  end

  context 'nearby Acceptance Test' do
    before(:each) do
    @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0)
    @dev3 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                          latitude: 25,
                          longitude: -100,
                          radius: 20.0)
    end

    it "send soul when others out of range and check it is not received" do
      post "/souls.json", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345, epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104" 
        } }
      expect(@dev3.histories.count).to be 0
    end

    it "device3 move into range and now send soul and check indeed received" do
      post "/souls.json", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345, epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" 
        } }
      device3_id = JSON.parse(response.body)["id"]
      patch "/devices/#{device3_id}.json",
        params: { device: { latitude: 30,
                          longitude: -100,
                          radius: 20.0,
                          token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
                        } }
      post "/souls.json", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345, epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104" 
        } }
      expect(@dev3.histories.count).to be 1
    end
  end

  context 'blocking Acceptance Test' do
    xit "1 sends a soul to another" do
    end

    xit "receiver has bad soul in history" do
    end

    xit "block bad sender" do
    end
    xit "check whether nearby works on both sides" do
    end
    xit "retry send soul" do
    end
    xit "check node script no push notif was sent" do
    end
    xit "send soul and check indeed received" do
    end
  end
end