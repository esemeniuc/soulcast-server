require 'rails_helper'

RSpec.describe Device, type: :model do
  before(:all) do
    # DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end

  before(:each) do
    @dev1 = Device.new(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                       latitude: 49.2812277842772,
                       longitude: -122.956075,
                       radius: 20.0,
                       os: "ios")

    @dev2 = Device.new(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                       latitude: 49.2812277842772,
                       longitude: -122.956075,
                       radius: 20.0,
                       os: "ios")
    @dev3 = Device.new(token:"dQb1nb_yE4A:APA91bEt5a-j61ufp09ImSVGrd9sXebq-uOHcdJ4TF6vTBgZO6scBVtPnewKP_TZb3LCxE_QF1M13HmC1rtqgg4Wo7Nm61JxDwmY-uBUlxLRBHnIC6NPoM9gS3bhUOU-UZKAnH2JxT4s",
                       latitude: 49.2812277842772,
                       longitude: -122.956075,
                       radius: 20.0,
                       os: "android")
  end

  it 'blocks other devices when asked' do
    @dev1.save
    @dev2.save

    @dev1.block(@dev2)
    lastBlock = Block.last
    expect(lastBlock.blocker_id).to be @dev1.id
    expect(lastBlock.blockee_id).to be @dev2.id
  end


  context "device validity tests" do
    it "should be valid with good input" do
      expect(@dev1).to be_valid
    end

    it "should not be valid when missing a token" do

      testDevice = Device.new(latitude: 49.2812277842772,
                              longitude: -122.956075,
                              radius: 20.0,
                              os: "ios")
      expect(testDevice).not_to be_valid
    end

    it "should not be valid with a nil token" do
      @dev1.token = nil
      expect(@dev1).not_to be_valid
    end
  end

  context "device reaches tests with a, b" do
    #test case 4
    it "should return true if a and b are on the same place" do
      expect(@dev1.in_mutual_radius?(@dev2)).to be true
      expect(@dev2.in_mutual_radius?(@dev1)).to be true
      expect(@dev3.in_mutual_radius?(@dev1)).to be true
      expect(@dev3.in_mutual_radius?(@dev2)).to be true
      expect(@dev1.in_mutual_radius?(@dev3)).to be true
      expect(@dev2.in_mutual_radius?(@dev3)).to be true
    end

    #test case 1
    context 'a and b areas do no overlap' do
      it "should return false" do
        @dev1.attributes = {latitude: 50,
                            longitude: -100,
                            radius: 20.0}
        @dev2.attributes = {latitude: 65,
                            longitude: -100,
                            radius: 10.0}

        expect(@dev1.in_mutual_radius?(@dev2)).to be false
        expect(@dev2.in_mutual_radius?(@dev1)).to be false
      end
    end
  end

  context "advanced reaches tests" do
    before(:each) do
      # DatabaseCleaner.clean_with(:truncation, reset_ids: true)
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

      @dev6 = Device.create(token:"dQb1nb_yE4A:APA91bEt5a-j61ufp09ImSVGrd9sXebq-uOHcdJ4TF6vTBgZO6scBVtPnewKP_TZb3LCxE_QF1M13HmC1rtqgg4Wo7Nm61JxDwmY-uBUlxLRBHnIC6NPoM9gS3bhUOU-UZKAnH2JxT4s",
                            latitude: 49.2812277842772,
                            longitude: -100,
                            radius: 20.0,
                            os: "android")

    end

    context "dev1 should reach dev2 and vice versa" do
      it "should reach each other" do
        expect(@dev1.in_mutual_radius?(@dev2)).to be true
        expect(@dev2.in_mutual_radius?(@dev1)).to be true
      end
    end

    context "dev1 should reach dev5 and vice versa" do
      it "should reach each other" do
        expect(@dev1.in_mutual_radius?(@dev5)).to be true
        expect(@dev5.in_mutual_radius?(@dev1)).to be true
      end
    end

    context "dev1 is near dev2 and dev5" do
      it "should have a valid number of nearby devices" do
        expect(@dev1.nearbyDeviceCount).to be 3
      end
    end

    context "dev1 is not near dev3" do
      it "should not reach test device" do
        expect(@dev1.in_mutual_radius?(@dev3)).to be false
        expect(@dev3.in_mutual_radius?(@dev1)).to be false
      end
    end

    context "dev1 is not near dev4" do
      it "should not reach test device" do
        expect(@dev1.in_mutual_radius?(@dev4)).to be false
        expect(@dev4.in_mutual_radius?(@dev1)).to be false
      end
    end

    context "dev1 (ios) is near dev6 (android) and vice versa" do
      it "should reach each other" do
        expect(@dev1.in_mutual_radius?(@dev6)).to be true
        expect(@dev6.in_mutual_radius?(@dev1)).to be true
      end
    end
  end

  context "reaches devices based on real world conditions" do
    before(:each) do

      deltaLongitudeInRadius = 9
      deltaLongitudeOutsideRadius = 11

      #dev1 at SFU CSIL
      @dev1 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                            latitude: 49.2812277842772,
                            longitude: -122.956075,
                            radius: 10.0,
                            os: "ios")
      #in radius
      @dev2 = Device.create(token: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                            latitude: 49.2812277842772 - deltaLongitudeInRadius,
                            longitude: -122.956075,
                            radius: 10.0,
                            os: "ios")
      #outside radius
      @dev3 = Device.create(token: "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
                            latitude: 49.2812277842772 - deltaLongitudeOutsideRadius,
                            longitude: -122.956075,
                            radius: 10.0,
                            os: "ios")
      #in radius
      @dev4 = Device.create(token: "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
                            latitude: 49.2812277842772,
                            longitude: -122.956075 + deltaLongitudeInRadius,
                            radius: 10.0,
                            os: "ios")
      #outside radius
      @dev5 = Device.create(token: "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE",
                            latitude: 49.2812277842772,
                            longitude: -122.956075 + deltaLongitudeOutsideRadius,
                            radius: 10.0,
                            os: "ios")
    end

    it "should correctly reach devices in range" do
      expect(@dev1.reaches?(@dev2)).to be true
      expect(@dev1.reaches?(@dev4)).to be true
    end

    it "should correctly not reach devices out of range" do
      expect(@dev1.reaches?(@dev3)).to be false
      expect(@dev1.reaches?(@dev5)).to be false
    end
  end

end


