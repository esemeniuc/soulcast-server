require 'rails_helper'

RSpec.describe HistoriesController, type: :controller do
  before(:all) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
    @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev2 = Device.create(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev3 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                          latitude: 25,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev4 = Device.create(token: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                          latitude: 75,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev5 = Device.create(token: "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
                          latitude: 60,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev6 = Device.create(token: "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
                          latitude: 40,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")
  end
  
  #add souls from 1 originating device to the history of the second device
  context "when no blocks are involved" do
    it "has no history when no souls are casted" do
      expect(@dev1.histories.count).to be 0 
    end

    it "dev1 has one history when dev2 casts a soul" do
      soul = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000000,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: @dev2.token,
                     device_id: @dev2.id)
      expect(@dev1.histories.count).to be 1
    end

    it "dev2 has one history when dev1 casts a soul" do
      soul = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000000,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: @dev1.token,
                     device_id: @dev1.id)
      expect(@dev2.histories.count).to be 1
    end

    it "dev2 has 3 histories when dev1 casts 3 souls" do
      soul1 = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000000,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: @dev1.token,
                     device_id: @dev1.id)
      soul2 = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000001,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: @dev1.token,
                     device_id: @dev1.id)
      soul3 = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000002,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: @dev1.token,
                     device_id: @dev1.id)
      expect(@dev2.histories.count).to be 3
    end

    it "recipient device has no history when someone casts a soul but too far" do
      castingDevice = Device.create(token: "castingDeviceToken",
                          latitude: -50,
                          longitude: 100,
                          radius: 10.0)
      receivingDevice = Device.create(token: "receivingDeviceToken",
                          latitude: 40,
                          longitude: -900,
                          radius: 10.0)
      soul = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000000,
                     latitude: 88,
                     longitude: -100,
                     radius: 0.001,
                     token: castingDevice.token,
                     device_id: castingDevice.id)
      expect(receivingDevice.histories.count).to be 0
    end
  end

  context "one device blocking another" do
    it 'causes history to exclude their soul' do
      soul = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000000,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: @dev2.token,
                     device_id: @dev2.id)

      expect(@dev1.histories.count).to be 1
      @dev1.block(@dev2)
      expect(@dev1.histories.count).to be 0
    end
  end

  context "dev1 is blocked by dev2, dev1 sends a soul to all nearby and not blocked" do
    it "should have no history for dev2 yet" do
      # expect to see soul from dev1 in history of dev2
      Block.create(blocker_id: @dev2.id, blockee_id: @dev1.id)
      expect(@dev2.histories.count).to be 0
    end
  end

  context "blocking after sending a soul" do
    # dev1 sends a soul to all nearby, dev1 is later blocked by dev2 and dev5
    # dev1 is reachable by dev2, dev5, and dev6
    before(:each) do
      @soul = Soul.create(soulType: "testType1",
                         s3Key: 10000000,
                         epoch: 1000000,
                         latitude: 50,
                         longitude: -100,
                         radius: 20,
                         token: @dev1.token,
                         device_id: @dev1.id)
    end
    it "should have no history for dev2" do
      expect(@dev2.histories.count).to be 1
      Block.create(blocker_id: @dev2.id, blockee_id: @dev1.id)
      expect(@dev2.histories.count).to be 0
    end

    it "should have no history for dev5" do
      expect(@dev5.histories.count).to be 1
      Block.create(blocker_id: @dev5.id, blockee_id: @dev1.id)
      expect(@dev5.histories.count).to be 0
    end

    it "should have history for dev6" do
      expect(@dev2.histories.count).to be 1
    end

    it "should have no history for dev3 (not reachable)" do
      expect(@dev3.histories.count).to be 0
    end

    it "should have no history for dev4 which is not reachable, but also later blocked" do
      Block.create(blocker_id: @dev4.id, blockee_id: @dev1.id)
      expect(@dev4.histories.count).to be 0
    end

    xit "should not make history for self" do

    end
  end

  context "blocking after both devices send a soul" do
    # dev1 sends a soul to all nearby, dev2 seconds a soul to all nearby
    # they are all reachable
    # dev2 later blocks dev1, so should show 0 histories for both

    it "should have no history for dev2, no history for dev1" do
      soul1 = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000000,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: @dev1.token,
                     device_id: @dev1.id)
      soul2 = Soul.create(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000001,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: @dev2.token,
                     device_id: @dev2.id)

      expect(@dev2.histories.count).to eq(1)
      expect(@dev1.histories.count).to eq(1)
      Block.create(blocker_id: @dev2.id, blockee_id: @dev1.id)
      expect(@dev2.histories.count).to eq(0)
      expect(@dev1.histories.count).to eq(0)
    end

  end

end
