require 'rails_helper'

RSpec.describe "blocks/edit", type: :view do
  before(:each) do
    @block = assign(:block, Block.create!(
      :blocker_token => "MyString",
      :blockee_token => "MyString",
      :blocker_id => 1,
      :blockee_id => 1
    ))
  end

  it "renders the edit block form" do
    render

    assert_select "form[action=?][method=?]", block_path(@block), "post" do

      assert_select "input#block_blocker_token[name=?]", "block[blocker_token]"

      assert_select "input#block_blockee_token[name=?]", "block[blockee_token]"

      assert_select "input#block_blocker_id[name=?]", "block[blocker_id]"

      assert_select "input#block_blockee_id[name=?]", "block[blockee_id]"
    end
  end
end
