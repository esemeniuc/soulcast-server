require 'rails_helper'

RSpec.describe "devices/new", type: :view do
  before(:each) do
    assign(:device, Device.new(
      :token => "MyString",
      :latitude => 1.5,
      :longitude => 1.5,
      :radius => 1.5,
      :os => "MyString"
    ))
  end

  it "renders new device form" do
    render

    assert_select "form[action=?][method=?]", devices_path, "post" do

      assert_select "input#device_token[name=?]", "device[token]"

      assert_select "input#device_latitude[name=?]", "device[latitude]"

      assert_select "input#device_longitude[name=?]", "device[longitude]"

      assert_select "input#device_radius[name=?]", "device[radius]"

      assert_select "input#device_os[name=?]", "device[os]"
    end
  end
end
