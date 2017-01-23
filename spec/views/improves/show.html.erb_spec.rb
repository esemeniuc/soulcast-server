require 'rails_helper'

RSpec.describe "improves/show", type: :view do
  before(:each) do
    @improve = assign(:improve, Improve.create!(
      :soulType => "Soul Type",
      :s3Key => "S3 Key",
      :epoch => 2,
      :latitude => 3.5,
      :longitude => 4.5,
      :radius => 5.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Soul Type/)
    expect(rendered).to match(/S3 Key/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/4.5/)
    expect(rendered).to match(/5.5/)
  end
end
