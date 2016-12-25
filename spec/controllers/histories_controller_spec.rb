require 'rails_helper'

def get_souls(history_array)
  history_array.map{|obj| obj.soul}
end

RSpec.describe HistoriesController, type: :controller do

  #create 2 devices
  before(:each) do
    @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0)

    @dev2 = Device.create(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0)
  end

  #add souls from 1 originating device to the history of the second device
  context "when no blocks are involved" do
    it "should send a soul from dev1 to dev2 and be in dev2's history" do
      # expect to see soul from dev1 in history of dev2
      @dev1.save
      soul = Soul.create(soulType: "testType1",
                          s3Key: 10000000,
                          epoch: 1000000,
                          latitude: 50,
                          longitude: -100,
                          radius: 20,
                          token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          device_id: @dev1.id)

      expect(@dev2.histories.find{|el| el.soul_id == soul.id}).not_to be_nil
    end
  end

  context "when dev1 is blocked by dev2" do
    it "should send a soul from dev1 to dev2 and not be in dev2's history" do
      # expect to see soul from dev1 in history of dev2
      @dev1.save
      @dev2.save
      block = Block.create(device_id: @dev2.id, blocked_device_id: @dev1.id)
      puts Block.all.inspect
      soul = Soul.create(soulType: "testType1",
                           s3Key: 10000000,
                           epoch: 1000000,
                           latitude: 50,
                           longitude: -100,
                           radius: 20,
                           token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                           device_id: @dev1.id)

      expect(@dev2.histories.find{|el| el.soul_id == soul.id}).to be_nil
    end
  end

end
