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
	context 'devices cast souls' do
		it 'sending no soul NO souls are in its history' do
			expect(@dev1.history.count).to be 0
		end
		it 'sending one soul causes history to have that soul' do
			#TODO: cast a soul from dev2 to dev1
			expect(@dev1.history.count).to be 1
		end
		it 'sending two souls causes history to have that soul' do
			#TODO: cast two souls from dev2 to dev1
			expect(@dev1.history.count).to be 2
			#TODO: compare soul ID/key instead of count...
		end
		it 'then one soul should be in both devices history' do
			#TODO: cast a soul from dev2 to dev1
			#TODO: cast a soul from dev1 to dev2
			expect(@dev1.history.count).to be 1
			expect(@dev2.history.count).to be 1
		end
		it 'then two souls should be in both devices history' do
			#TODO: cast two souls from dev2 to dev1
			#TODO: cast two souls from dev1 to dev2
			expect(@dev1.history.count).to be 2
			expect(@dev2.history.count).to be 2
		end
	end

end
