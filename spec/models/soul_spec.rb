require 'rails_helper'

RSpec.describe Soul, type: :model do

  before(:all) do
    @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0)

  end

  it "should create a soul with valid input" do
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
end
