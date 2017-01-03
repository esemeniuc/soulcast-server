require 'rails_helper'

RSpec.describe Device, type: :model do
  before(:all) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end
  context "device validity tests" do
    it "should be valid with good input" do
      testDevice = Device.new(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                              latitude: 49.2812277842772,
                              longitude: -122.956075,
                              radius: 20.0)
      expect(testDevice).to be_valid
    end

    it "should not be valid when missing a token" do
      testDevice = Device.new(latitude: 49.2812277842772,
                              longitude: -122.956075,
                              radius: 20.0)
      expect(testDevice).not_to be_valid
    end

    it "should not be valid with a nil token" do
      testDevice = Device.new(token: nil,
                              latitude: 49.2812277842772,
                              longitude: -122.956075,
                              radius: 20.0)
      expect(testDevice).not_to be_valid
    end
  end

  context "device reaches tests with a, b" do
    #test case 4
    it "should return true if a and b are on the same place" do
      a = Device.new(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                     latitude: 49.2812277842772,
                     longitude: -122.956075,
                     radius: 20.0)
      b = Device.new(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                     latitude: 49.2812277842772,
                     longitude: -122.956075,
                     radius: 20.0)

      expect(a.reaches?(b)).to be true
      expect(b.reaches?(a)).to be true
    end

    #test case 1
    context 'a and b areas do no overlap' do
      it "should return false" do
        a = Device.new(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                       latitude: 50,
                       longitude: -100,
                       radius: 20.0)
        b = Device.new(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                       latitude: 65,
                       longitude: -100,
                       radius: 10.0)

        expect(a.reaches?(b)).to be false
        expect(b.reaches?(a)).to be false
      end
    end
  end

  context "advanced reaches tests" do

    before(:each) do
      DatabaseCleaner.clean_with(:truncation, reset_ids: true)
      @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                            latitude: 50,
                            longitude: -100,
                            radius: 20.0)

      @dev2 = Device.create(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                            latitude: 50,
                            longitude: -100,
                            radius: 20.0)

      @dev3 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                            latitude: 25,
                            longitude: -100,
                            radius: 20.0)

      @dev4 = Device.create(token: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                            latitude: 75,
                            longitude: -100,
                            radius: 20.0)

      @dev5 = Device.create(token: "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
                            latitude: 60,
                            longitude: -100,
                            radius: 20.0)
    end

    context "dev1 should reach dev2 and vice versa" do
      it "should reach each other" do
        expect(@dev1.reaches?(@dev2)).to be true
        expect(@dev2.reaches?(@dev1)).to be true
      end
    end

    context "dev1 should reach dev5 and vice versa" do
      it "should reach each other" do
        expect(@dev1.reaches?(@dev5)).to be true
        expect(@dev5.reaches?(@dev1)).to be true
      end
    end

    context "dev1 is near dev2 and dev5" do
      it "should have a valid number of nearby devices" do
        expect(@dev1.nearbyDeviceCount).to be 2
      end
    end

    context "dev1 is not near dev3" do
      it "should not reach test device" do
        expect(@dev1.reaches?(@dev3)).to be false
        expect(@dev3.reaches?(@dev1)).to be false
      end
    end

    context "dev1 is not near dev4" do
      it "should not reach test device" do
        expect(@dev1.reaches?(@dev4)).to be false
        expect(@dev4.reaches?(@dev1)).to be false
      end
    end
  end

  it 'blocks other devices when asked' do
    testDevice1 = Device.create(token: "testDevice1token",
                            latitude: 49.2812277842772,
                            longitude: -122.956075,
                            radius: 20.0)
    testDevice2 = Device.create(token: "testdevice2token",
                            latitude: 49.2812277842772,
                            longitude: -122.956075,
                            radius: 20.0)
    testDevice1.block(testDevice2)
    lastBlock = Block.last
    expect(lastBlock.blocker_id).to be testDevice1.id
    expect(lastBlock.blockee_id).to be testDevice2.id
  end

end


