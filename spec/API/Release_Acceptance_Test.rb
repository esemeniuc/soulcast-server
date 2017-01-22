require "rails_helper"

RSpec.describe "Acceptance Test", :type => :request do
  before(:each) do
      DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end

  context 'cast soul Acceptance test' do
    it "registers device" do
      post "/devices.json", 
        params: { device: {
        latitude:100, 
        longitude:100, 
        radius:20, 
        token:"12345asdfgqwerty" } }
      expect(response).to have_http_status(201) 
    end

    xit "receives id" do
    end

    xit "sends soul" do
    end

    xit "receives confirmation" do
    end
  end

  context 'nearby Acceptance Test' do
    xit "send soul when others out of range" do
    end
    xit "check it is not received" do
    end
    xit "others move into range" do
    end
    xit "send soul and check indeed received" do
    end
  end

  context 'blocking Acceptance Test' do
    xit "1 sends a soul to another" do
    end

    xit "receiver has bad soul in history" do
    end

    xit "block bad sender" do
    end
    xit "check whether nearby works on both sides" do
    end
    xit "retry send soul" do
    end
    xit "check node script no push notif was sent" do
    end
    xit "send soul and check indeed received" do
    end
  end
end