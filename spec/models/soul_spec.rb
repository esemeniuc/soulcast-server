require 'rails_helper'

RSpec.describe Soul, type: :model do

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
  end

  context "soul creation tests" do

    context "with valid input" do
      it "should save a soul to the database with device_id" do
        soul1 = Soul.create(soulType: "testType1",
                          s3Key: 10000000,
                          epoch: 1000000,
                          latitude: 50,
                          longitude: -100,
                          radius: 20,
                          device_id: @dev1.id)

        expect(Soul.all.count).to be 1
      end

      it "should save a soul to the database without device_id" do
        soul1 = Soul.create(soulType: "testType1",
                             s3Key: 10000000,
                             epoch: 1000000,
                             latitude: 50,
                             longitude: -100,
                             radius: 20)

        expect(Soul.all.count).to be 1
      end

      it "should update the device location when saving" do
        soul1 = Soul.create(soulType: "testType1",
                            s3Key: 10000000,
                            epoch: 1000000,
                            latitude: 55,
                            longitude: -111,
                            radius: 22)

        expect(Device.find(@dev1.id).latitude).to eq soul1.latitude
        expect(Device.find(@dev1.id).longitude).to eq soul1.longitude
        expect(Device.find(@dev1.id).radius).to eq soul1.radius
      end

      it "should android push to Eric's device" do
        recipient = ['cokb_316jF4:APA91bG0lBda5_a8oiQVQyKODfTnCc9s-nBklDOeLa1PqBXo50i0aA1_hJACfWTBztSO46rZp8B3IZ77O180H8uYnoH0KFxsYLDAYOcyBf86O6sAOmAjJCkRAzpSgcoa13okNFPcuvwi']
        soulobj = {'soulObject': {s3Key: 1494193409335}}
        payload = {data: soulobj}
        FirebaseHelper.androidFCMPush(recipient, payload)
      end

    end

    context "with invalid input" do
      it "should not save a soul to the database with nil token" do
        soul1 = Soul.create(soulType: "testType1",
                             s3Key: 10000000,
                             epoch: 1000000,
                             latitude: 50,
                             longitude: -100,
                             radius: 20,
                             token: nil)

        expect(Soul.all.count).to be 0
      end

      it "should not save a soul to the database with token not in devices" do
        soul1 = Soul.create(soulType: "testType1",
                             s3Key: 10000000,
                             epoch: 1000000,
                             latitude: 50,
                             longitude: -100,
                             radius: 20,
                             token: "not a token")

        expect(Soul.all.count).to be 0
      end

      it "should not save soul with epoch longer than 10 digits" do
        soul1 = Soul.create(soulType: "testType1",
                            s3Key: 10000000,
                            epoch: 1982471912415,
                            latitude: 55,
                            longitude: -111,
                            radius: 22,
                            token: @dev1.token)
        expect(soul1.valid?).to be false
      end

      it "should not save a soul to the database with no s3key" do
        soul1 = Soul.create(soulType: "testType1",
                            epoch: 1000000,
                            latitude: 50,
                            longitude: -100,
                            radius: 20,
                            token: @dev1.token)

        expect(Soul.all.count).to be 0
      end

      it "should not update the device without s3key" do
        soul1 = Soul.create(soulType: "testType1",
                            epoch: 1000000,
                            latitude: 55,
                            longitude: -111,
                            radius: 22,
                            token: @dev1.token)

        expect(Device.find(@dev1.id).latitude).to eq 50
        expect(Device.find(@dev1.id).longitude).to eq -100
        expect(Device.find(@dev1.id).radius).to eq 20
      end
    end
  end

  context "generate JSON String tests" do

    before(:each) do
      @soul1 = Soul.new(soulType: "testType1",
                        s3Key: 10000000,
                        epoch: 1000000,
                        latitude: 50,
                        longitude: -100,
                        radius: 20,
                        token: @dev1.token,
                        device_id: @dev1.id)
    end
    context "1 or more devices" do
      it "should generate a valid JSON String with 1 device" do
        testString = @soul1.generateJSONString([@dev2])
        expect(testString).not_to be nil
        expect(testString.split[-1]).to eq @dev2.token #check what tokens the soul is sent to
      end

      it "should generate a valid JSON String with 3 devices" do
        testString = @soul1.generateJSONString([@dev2, @dev3, @dev4])
        splitString = testString.split
        @soul1.broadcast([@dev2, @dev3, @dev4])
        expect(testString).not_to be nil
        expect(splitString[-1]).to eq @dev4.token #check what tokens the soul is sent to
        expect(splitString[-2]).to eq @dev3.token + '\\' #weird bug
        expect(splitString[-3]).to eq @dev2.token + '\\' #weird bug
      end
    end

    context "no devices" do
      it "should return a nil string" do
        testString = @soul1.generateJSONString([])
        expect(testString).to be nil
      end
    end
  end
end
