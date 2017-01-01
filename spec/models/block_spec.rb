require 'rails_helper'

RSpec.describe Block, type: :model do
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

  context "validation tests" do
    context "with valid input" do
      it "should save the block" do
        block = Block.create(blocker_token: @dev1.token, blockee_token: @dev2.token)
        expect(Block.all.count).to be 1
        expect(block.blocker_id).to be @dev1.id
        expect(block.blockee_id).to be @dev2.id
      end
    end

    context "with invalid input" do
      it "should not save the block with 1 bad token" do
        expect{Block.create(blocker_token: "ZZZ", blockee_token: @dev2.token)}.to raise_error(ActiveRecord::RecordNotFound)
        expect(Block.all.count).to be 0
      end

      it "should not save the block with 1 bad token" do
        expect{Block.create(blocker_token: @dev1.token, blockee_token: "YYY")}.to raise_error(ActiveRecord::RecordNotFound)
        expect(Block.all.count).to be 0
      end

      it "should not save the block with 2 bad tokens" do
        expect{Block.create(blocker_token: "ZZZ", blockee_token: "YYY")}.to raise_error(ActiveRecord::RecordNotFound)
        expect(Block.all.count).to be 0
      end
    end

  end

  context "devices blocking each other" do
    context "after dev2 blocks dev1 when they are nearby" do
      before(:each) do
        Block.create(blocker_token: @dev2.token, blockee_token: @dev1.token)
        @soul1 = Soul.create(soulType: "testType1",
                            s3Key: 10000000,
                            epoch: Time.now.to_i,
                            latitude: 50,
                            longitude: -100,
                            radius: 20,
                            token: @dev1.token,
                            device_id: @dev1.id)
      end

      it "should allow another nearby device to receive from dev1" do
        expect(@dev5.histories.count).to be 1
      end

      it "should not allow dev2 to receive from dev1" do
        expect(@dev2.histories.count).to be 0
      end

      context "dev4 also blocks dev1, but isn't nearby" do
        it "should still not allow dev4 to receive from dev1" do
          expect(@dev4.histories.count).to be 0
        end
      end
     end

    context "dev 2 and dev5 block dev1, and both dev2 and dev5 are nearby" do
      it "should not allow dev5 to receive from dev1" do
        Block.create(blocker_token: @dev5.token, blockee_token: @dev1.token)
        Block.create(blocker_token: @dev2.token, blockee_token: @dev1.token)
        @soul1 = Soul.create(soulType: "testType1",
                             s3Key: 10000000,
                             epoch: Time.now.to_i,
                             latitude: 50,
                             longitude: -100,
                             radius: 20,
                             token: @dev1.token,
                             device_id: @dev1.id)
        expect(@dev5.histories.count).to be 0
      end
    end

  end
end
