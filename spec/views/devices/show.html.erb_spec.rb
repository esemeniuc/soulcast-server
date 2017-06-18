require 'rails_helper'

RSpec.describe "devices/show", type: :view do
  before(:each) do
    @device = assign(:device, Device.create!(
      :token => "Token",
      :latitude => 2.5,
      :longitude => 3.5,
      :radius => 4.5,
      :os => "ios"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Token/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/4.5/)
    expect(rendered).to match(/ios/)
  end
end
