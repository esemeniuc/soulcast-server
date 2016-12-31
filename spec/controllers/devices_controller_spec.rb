require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
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

  it "should have accurate reaches" do
    expect(@dev1.reaches(@dev2)).to be true
    expect(@dev1.reaches(@dev5)).to be true
    expect(@dev1.reaches(@dev3)).to be false
    expect(@dev1.reaches(@dev4)).to be false
    expect(@dev1.nearbyDeviceCount).to be 2
  end

  context "valid device input" do
    it "should be able to register and receive response that it was successful" do
      post :create, params: {device: {token: "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
                                              latitude: 50,
                                              longitude: -100,
                                              radius: 20.0}}
      puts response.body

      # expect(response).to have_http_status(:created)
      # expect(assigns(:@dev1)).to be_a_new(Device)
    end
  end
end
