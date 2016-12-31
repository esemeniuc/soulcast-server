require 'rails_helper'

RSpec.describe Soul, type: :model do

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

  context "soul creation tests" do

    context "with valid input" do
      it "should save a soul to the database with device_id" do
        @soul1 = Soul.create(soulType: "testType1",
                          s3Key: 10000000,
                          epoch: 1000000,
                          latitude: 50,
                          longitude: -100,
                          radius: 20,
                          token: @dev1.token,
                          device_id: @dev1.id)

        expect(Soul.all.count).to be 1
      end

      it "should save a soul to the database without device_id" do
        @soul1 = Soul.create(soulType: "testType1",
                             s3Key: 10000000,
                             epoch: 1000000,
                             latitude: 50,
                             longitude: -100,
                             radius: 20,
                             token: @dev1.token)

        expect(Soul.first.device.id).to be 1
        expect(Soul.all.count).to be 1
      end
    end

    context "with invalid input" do
      it "should not save a soul to the database with nil token" do
        @soul1 = Soul.create(soulType: "testType1",
                             s3Key: 10000000,
                             epoch: 1000000,
                             latitude: 50,
                             longitude: -100,
                             radius: 20,
                             token: nil)

        expect(Soul.all.count).to be 0
      end

      it "should not save a soul to the database with token not in devices" do
        @soul1 = Soul.create(soulType: "testType1",
                             s3Key: 10000000,
                             epoch: 1000000,
                             latitude: 50,
                             longitude: -100,
                             radius: 20,
                             token: "not a token")

        expect(Soul.all.count).to be 0
      end
    end
  end

  it "should have devicesWithinMutualRange"

  xit "shoul generate a valid JSON String"

end
