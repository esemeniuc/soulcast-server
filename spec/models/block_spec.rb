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

      it "should not save the block with 2 bad tokens" do
        expect{Block.create(blocker_token: "ZZZ", blockee_token: "YYY")}.to raise_error(ActiveRecord::RecordNotFound)
        expect(Block.all.count).to be 0
      end
    end

  end

  context "blocking tests" do
    context "dev1 blocks dev2, both are nearby" do
      it "should allow dev1 to send to dev5" do
        Block.create(blocker_token: @dev1.token, blockee_token: @dev2.token)
        soul1 = Soul.create(soulType: "testType1",
                            s3Key: 10000000,
                            epoch: 1000000,
                            latitude: 50,
                            longitude: -100,
                            radius: 20,
                            token: @dev1.token,
                            device_id: @dev1.id)

        expect(@dev5.histories.count).to be 1
      end
    end
  end

end
