require 'rails_helper'

RSpec.describe History, type: :model do
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

    @soul1 = Soul.new(soulType: "testType1",
                         s3Key: 10000000,
                         epoch: Time.now.to_i,
                         latitude: 50,
                         longitude: -100,
                         radius: 20,
                         token: @dev1.token,
                         device_id: @dev1.id)
  end

  context "test make_history" do
    xit "should add no history records for no input devices" do
      History.make_history([], @soul1)
      expect(History.all.count).to be 0
    end

    it "should add history records for no input devices" do

    end
  end
end
