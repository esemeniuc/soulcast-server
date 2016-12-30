require 'rails_helper'

RSpec.describe BlocksController, type: :controller do
	context 'when device1 blocks device2' do
		it 'should have successfully blocked device2' do
			#expect(device1.blocks.contains)=device2
			#expect(device2.beingblocked.contains)=device1
		end
	end
	context 'when device1 did NOT block device2' do
		it 'should NOT have blocked device2' do
			#expect(device1.blocks.contains)= no device2
			#expect(device2.beingblocked.contains)= no device1
		end
	end
	context 'when device1 blocks device2 but not device3' do
		it 'should have blocked device2' do
			#expect(device1.blocks.contains)= device2
			#expect(device2.beingblocked.contains)= device1
		end
		it 'should NOT have blocked device3' do
			#expect(device1.blocks.contains)= no device3
			#expect(device3.beingblocked.contains)= no device1
		end
	end
end
