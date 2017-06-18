require 'rails_helper'

RSpec.describe "blocks/new", type: :view do
  before(:each) do
    assign(:block, Block.new(
      :blocker_id => "",
      :blockee_id => 1
    ))
  end

  it "renders new block form" do
    render

    assert_select "form[action=?][method=?]", blocks_path, "post" do

      assert_select "input#block_blocker_id[name=?]", "block[blocker_id]"

      assert_select "input#block_blockee_id[name=?]", "block[blockee_id]"
    end
  end
end
