require 'rails_helper'

RSpec.describe "improves/index", type: :view do
  before(:each) do
    assign(:improves, [
      Improve.create!(
        :soulType => "Soul Type",
        :s3Key => "S3 Key",
        :epoch => 2,
        :latitude => 3.5,
        :longitude => 4.5,
        :radius => 5.5
      ),
      Improve.create!(
        :soulType => "Soul Type",
        :s3Key => "S3 Key",
        :epoch => 2,
        :latitude => 3.5,
        :longitude => 4.5,
        :radius => 5.5
      )
    ])
  end

  it "renders a list of improves" do
    render
    assert_select "tr>td", :text => "Soul Type".to_s, :count => 2
    assert_select "tr>td", :text => "S3 Key".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.5.to_s, :count => 2
    assert_select "tr>td", :text => 4.5.to_s, :count => 2
    assert_select "tr>td", :text => 5.5.to_s, :count => 2
  end
end
