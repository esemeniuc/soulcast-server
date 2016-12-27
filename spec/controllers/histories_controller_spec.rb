require 'rails_helper'

RSpec.describe HistoriesController, type: :controller do
	context 'when one device had already received souls' do
		xit 'one souls received'do
			#expect(device1.history)=one soul
		end
		xit 'two souls received'do
			#expect(device1.history)=two souls
		end
		xit 'three souls received'do
			#expect(device1.history)=three souls
		end
	end
	context 'when one device had NOT received any souls' do
		xit 'No souls received' do
			#expect(device1.history)= nosouls
		end
	end
	context 'when two devices had already received souls' do
		xit 'one souls received'do
			#expect(device1.history)=one soul
			#expect(device2.history)=one soul
		end
		xit 'two souls received'do
			#expect(device1.history)=two souls
			#expect(device2.history)=two souls
		end
		xit 'three souls received'do
			#expect(device1.history)=three souls
			#expect(device2.history)=thres souls
		end
	end

end
