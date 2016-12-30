require 'rails_helper'

RSpec.describe "blocks/show", type: :view do
  before(:each) do
    @block = assign(:block, Block.create!(
      :blocker_token => "Blocker Token",
      :blockee_token => "Blockee Token",
      :blocker_id => 2,
      :blockee_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Blocker Token/)
    expect(rendered).to match(/Blockee Token/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
