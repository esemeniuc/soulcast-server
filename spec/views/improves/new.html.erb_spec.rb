require 'rails_helper'

RSpec.describe "improves/new", type: :view do
  before(:each) do
    assign(:improve, Improve.new(
      :soulType => "MyString",
      :s3Key => "MyString",
      :epoch => 1,
      :latitude => 1.5,
      :longitude => 1.5,
      :radius => 1.5
    ))
  end

  it "renders new improve form" do
    render

    assert_select "form[action=?][method=?]", improves_path, "post" do

      assert_select "input#improve_soulType[name=?]", "improve[soulType]"

      assert_select "input#improve_s3Key[name=?]", "improve[s3Key]"

      assert_select "input#improve_epoch[name=?]", "improve[epoch]"

      assert_select "input#improve_latitude[name=?]", "improve[latitude]"

      assert_select "input#improve_longitude[name=?]", "improve[longitude]"

      assert_select "input#improve_radius[name=?]", "improve[radius]"
    end
  end
end
