require 'rails_helper'

RSpec.describe HistoriesController, type: :controller do
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
	context 'when a device has NOT received any souls,' do
		it 'then NO souls are in its history' do
			expect(@dev1.history.count).to be 0
		end
	end
	context 'when a device has received one soul,' do
		it 'then one soul is in its history'do
			expect(@dev1.history.count).to be 1
		end
	end
	context 'when a device has received two souls,' do
		it 'then two souls are in its history'do
			expect(@dev1.history.count).to be 2
		end
	end
	context 'when two devices have each received a soul,' do
		it 'then one soul should be in both devices history'do
			expect(@dev1.history.count).to be 1
			expect(@dev2.history.count).to be 1
		end
	end
	context 'when two devices have each received two souls,' do
		it 'then two souls should be in both devices history'do
			expect(@dev1.history.count).to be 2
			expect(@dev2.history.count).to be 2
		end
	end

end
