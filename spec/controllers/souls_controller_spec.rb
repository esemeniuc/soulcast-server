require 'rails_helper'

RSpec.describe SoulsController, type: :controller do
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
                            latitude: 50,
                            longitude: -100,
                            radius: 20.0,
                            os: "android")
  end

	context 'does end to end transmission' do
		it 'when casting a soul within mutual radius of another' do
			soul1 = Soul.create(soulType: "testType1",
				s3Key: 10000000,
				epoch: 1000000,
				latitude: 50,
				longitude: -100,
				radius: 20,
				token: @dev1.token)
			expect(@dev2.histories.count).to be 1
			expect(@dev6.histories.count).to be 1
		end
		it 'when casting a soul within mutual radius of another' do
			soul6 = Soul.create(soulType: "testType1",
				s3Key: 10000000,
				epoch: 1000000,
				latitude: 50,
				longitude: -100,
				radius: 20,
				token: @dev6.token)
			expect(@dev1.histories.count).to be 1
			expect(@dev2.histories.count).to be 1
		end

		it 'when casting a soul NOT within mutual radius of another' do
			soul1 = Soul.create(soulType: "testType1",
				s3Key: 10000000,
				epoch: 1000000,
				latitude: 50,
				longitude: -100,
				radius: 20,
				token: @dev1.token)
			expect(@dev3.histories.count).to be 0
		end
	end
	context 'Nearby' do #FIXME: tests are not passing because test expectations are wrong
		it 'four devices are within mutual radius' do
			expect(@dev1.nearbyDeviceCount).to be 3
			expect(@dev2.nearbyDeviceCount).to be 3
			expect(@dev5.nearbyDeviceCount).to be 4
			expect(@dev6.nearbyDeviceCount).to be 3
		end
		it 'No three devices are within mutual radius' do
			expect(@dev2.nearbyDeviceCount).to be 3
			expect(@dev3.nearbyDeviceCount).to be 0
			expect(@dev4.nearbyDeviceCount).to be 1
		end
	end

	context 'devices in mutual of dev6 (android)' do
		it 'two devices are within mutual radius' do
			expect(@dev6.nearbyDeviceCount).to be 3
			# expect(@dev7.nearbyDeviceCount).to be 1
		end

		it 'no devices mutual in dev8' do
			expect(@dev3.nearbyDeviceCount).to be 0
		end
		it 'Cast a soul not within mutal radius of another' do
			soul1 = Soul.create(soulType: "testType1",
				s3Key: 10000000,
				epoch: 1000000,
				latitude: 49.277712,
                longitude: -122.914274,
				radius: 10,
				token: @dev6.token)
			expect(@dev1.histories.count).to be 0
			expect(@dev3.histories.count).to be 0
		end
	end
end
