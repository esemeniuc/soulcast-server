require 'rails_helper'

RSpec.describe "improves/edit", type: :view do
  before(:each) do
    @improve = assign(:improve, Improve.create!(
      :soulType => "MyString",
      :s3Key => "MyString",
      :epoch => 1,
      :latitude => 1.5,
      :longitude => 1.5,
      :radius => 1.5,
      :token => "MyString",
      :device => nil
    ))
  end

  it "renders the edit improve form" do
    render

    assert_select "form[action=?][method=?]", improve_path(@improve), "post" do

      assert_select "input#improve_soulType[name=?]", "improve[soulType]"

      assert_select "input#improve_s3Key[name=?]", "improve[s3Key]"

      assert_select "input#improve_epoch[name=?]", "improve[epoch]"

      assert_select "input#improve_latitude[name=?]", "improve[latitude]"

      assert_select "input#improve_longitude[name=?]", "improve[longitude]"

      assert_select "input#improve_radius[name=?]", "improve[radius]"

      assert_select "input#improve_token[name=?]", "improve[token]"

      assert_select "input#improve_device_id[name=?]", "improve[device_id]"
    end
  end
end
