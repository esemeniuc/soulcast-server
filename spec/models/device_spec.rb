require 'rails_helper'

RSpec.describe Device, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it "should be valid with good input" do
    testDevice = Device.new(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                            latitude: 49.2812277842772,
                            longitude: -122.956075,
                            radius: 20.0)
    expect(testDevice).to be_valid
  end

  it "should not be valid missing a token" do
    testDevice = Device.new(latitude: 49.2812277842772,
                            longitude: -122.956075,
                            radius: 20.0)
    expect(testDevice).not_to be_valid
  end

  it "should not be valid with a nil token" do
    testDevice = Device.new(token: nil,
                            latitude: 49.2812277842772,
                            longitude: -122.956075,
                            radius: 20.0)
    expect(testDevice).not_to be_valid
  end

  #test case 4
  it "should return true if a and b are on the same place" do
    a = Device.new(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                            latitude: 49.2812277842772,
                            longitude: -122.956075,
                            radius: 20.0)
    b = Device.new(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                   latitude: 49.2812277842772,
                   longitude: -122.956075,
                   radius: 20.0)

    expect(a.reaches(b)).to be true
    expect(b.reaches(a)).to be true

  end

  #test case 4
  it "should return true if a and b are on the same place" do
    a = Device.new(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                   latitude: 49.2812277842772,
                   longitude: -122.956075,
                   radius: 20.0)
    b = Device.new(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                   latitude: 49.2812277842772,
                   longitude: -122.956075,
                   radius: 20.0)

    expect(a.reaches(b)).to be true
    expect(b.reaches(a)).to be true
  end

  #test case 1
  context 'a and b areas do no overlap' do
    it "should return false" do
      a = Device.new(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                     latitude: 50,
                     longitude: -100,
                     radius: 20.0)
      b = Device.new(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                     latitude: 65,
                     longitude: -100,
                     radius: 10.0)

      expect(a.reaches(b)).to be false
      expect(b.reaches(a)).to be false
    end
  end

end


