require 'rails_helper'

RSpec.describe "blocks/index", type: :view do
  before(:each) do
    assign(:blocks, [
      Block.create!(
        :blocker_token => "Blocker Token",
        :blockee_token => "Blockee Token",
        :blocker_id => 2,
        :blockee_id => 3
      ),
      Block.create!(
        :blocker_token => "Blocker Token",
        :blockee_token => "Blockee Token",
        :blocker_id => 2,
        :blockee_id => 3
      )
    ])
  end

  xit "renders a list of blocks" do
    render
    assert_select "tr>td", :text => "Blocker Token".to_s, :count => 2
    assert_select "tr>td", :text => "Blockee Token".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
