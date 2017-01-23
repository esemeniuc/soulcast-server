require "rails_helper"

RSpec.describe "Acceptance Test", :type => :request do
  before(:each) do
      DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end

  context 'cast soul Acceptance test' do
    post "/devices.json", 
        params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"12345asdfgqwerty" } }

    it "registers device" do
      expect(response).to have_http_status(201) 
    end

    it "receives id" do
      device_id = JSON.parse(response.body)["id"]
      expect(device_id).to be 100
    end

    it "sends soul" do
      post "/souls.json", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345, epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"12345asdfgqwerty" } }
      expect(response).to have_http_status(201)
    end

    xit "receives confirmation" do
    end
  end

  context 'nearby Acceptance Test' do
    @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0)
    @dev3 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                          latitude: 25,
                          longitude: -100,
                          radius: 20.0)
    device_id = JSON.parse(response.body)["id"]

    xit "send soul when others out of range" do
      post "/souls.json", 
      params: { soul: {
        soulType: "RSpecTestSoul", 
        s3Key: 12345, epoch:123456789, 
        latitude:100, longitude:100, radius:20, 
        token:"5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104" } }
    end

    xit "check it is not received" do
      expect(@dev3.histories.count).to be 0
    end

    xit "others move into range" do
      patch "/devices/#{device_id}.json",
        params: { device: { latitude: 30,
                          longitude: -100,
                          radius: 20.0,
                          token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
                        } }
    end

    xit "send soul and check indeed received" do
      expect(@dev3.histories.count).to be 0
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