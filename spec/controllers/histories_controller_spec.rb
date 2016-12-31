require 'rails_helper'

RSpec.describe HistoriesController, type: :controller do

  #create 2 devices
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

    @soul = Soul.new(soulType: "testType1",
                     s3Key: 10000000,
                     epoch: 1000000,
                     latitude: 50,
                     longitude: -100,
                     radius: 20,
                     token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                     device_id: @dev1.id)
  end

  #add souls from 1 originating device to the history of the second device
  context "when no blocks are involved" do
    it "should send a soul from dev1 to dev2 and be in dev2's history" do
      # expect to see soul from dev1 in history of dev2
      @soul.save
      expect(@dev2.histories.find{|el| el.soul_id == @soul.id}).not_to be_nil
    end
  end

  context "dev1 is blocked by dev2, dev1 sends a soul to all nearby and not blocked" do
    it "should have no history for dev2" do
      # expect to see soul from dev1 in history of dev2
      Block.create(blocker_id: @dev2.id, blockee_id: @dev1.id)
      @soul.save #needed because we want to block before sending
      expect(@dev2.histories.find{|el| el.soul_id == @soul.id}).to be_nil
    end
  end

  context 'when a device has NOT received any souls,' do
    it 'then NO souls are in its history' do
      expect(@dev1.histories.count).to be 0
    end
  end
  context 'when a device has received one soul,' do
    it 'should have one soul in its history'do
      expect(@dev1.histories.count).to be 1
    end
  end
  context 'when a device has received two souls,' do
    it 'then two souls are in its history'do
      expect(@dev1.histories.count).to be 2
    end
  end
  context 'when two devices have each received a soul,' do
    it 'then one soul should be in both devices history'do
      expect(@dev1.histories.count).to be 1
      expect(@dev2.histories.count).to be 1
    end
  end
  context 'when two devices have each received two souls,' do
    it 'then two souls should be in both devices history'do
      expect(@dev1.histories.count).to be 2
      expect(@dev2.histories.count).to be 2
    end
  end

end
