require "rails_helper"

RSpec.describe "Acceptance Test", :type => :request do
  before(:each) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end

  xit "when blocking, history removal must be mutual" do

  end

  xit "2 to 1 nearby test" do

  end

#TODO: make it cast to another device...
  context 'cast soul' do
    @castingToken = "12345asdfgqwerty"
    before(:each) do
      post "/devices.json",
           params: { device: {
               latitude:100,
               longitude:100,
               radius:20,
               token: @castingToken} }

      #TODO: make another device...

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
               token: @castingToken } }
      expect(response).to have_http_status(201)
      #TODO: check node script receipt
    end
  end
#TODO: rename...
  context 'nearby device 3' do
    before(:each) do
      @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                            latitude: 50,
                            longitude: -100,
                            radius: 20.0,
                            os: "ios")
      @dev3 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                            latitude: 25,
                            longitude: -100,
                            radius: 20.0,
                            os: "ios")
    end

    it "does not receive soul when out of range" do
      post "/souls.json",
           params: { soul: {
               soulType: "RSpecTestSoul",
               s3Key: 12345, epoch:123456789,
               latitude:100, longitude:100, radius:20,
               token:"5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104"
           } }
      #expect(@dev3.histories.count).to be 0
    end

#TODO: rename
    it "can listen to soul only when in range" do
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
                                token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                                os: "ios"
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
    before(:each) do
      @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                            latitude: 50,
                            longitude: -100,
                            radius: 20.0,
                            ios: "os")
      @dev3 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                            latitude: 30,
                            longitude: -100,
                            radius: 20.0,
                            ios: "os")
    end

    it "dev1 sends a soul, dev3 block dev1, and check nearby" do
      get "/nearby", params: { latitude:100,
                               longitude:100,
                               radius:20,
                               token:"5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104" }
      dev1nearby_count = JSON.parse(response.body)["nearby"]
      expect(dev1nearby_count).to be 1
      get "/nearby", params: { latitude:100,
                               longitude:100,
                               radius:20,
                               token:"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" }
      dev3nearby_count = JSON.parse(response.body)["nearby"]
      expect(dev3nearby_count).to be 1
      post "/souls.json",
           params: { soul: {
               soulType: "RSpecTestSoul",
               s3Key: 12345, epoch:123456789,
               latitude:50, longitude:-100, radius:20,
               token:"5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104"
           } }
      post "/blocks.json",
           params: { block: {
               blocker_token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
               blockee_token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104"
           } }
      get "/nearby", params: { latitude:100,
                               longitude:100,
                               radius:20,
                               token:"5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104" }
      dev1nearby_count = JSON.parse(response.body)["nearby"]
      expect(dev1nearby_count).to be 0
      get "/nearby", params: { latitude:100,
                               longitude:100,
                               radius:20,
                               token:"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" }
      dev3nearby_count = JSON.parse(response.body)["nearby"]
      expect(dev3nearby_count).to be 0
    end

    it "retry send soul and check indeed not received " do
      post "/blocks.json",
           params: { block: {
               blocker_token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
               blockee_token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104"
           } }
      post "/souls.json",
           params: { soul: {
               soulType: "RSpecTestSoul",
               s3Key: 12345, epoch:123456789,
               latitude:50, longitude:-100, radius:20,
               token:"5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104"
           } }
      expect(@dev3.histories.count).to be 0
    end

    xit "check node script no push notif was sent" do
    end
  end
end