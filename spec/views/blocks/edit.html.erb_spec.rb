require 'rails_helper'

RSpec.describe "blocks/edit", type: :view do
  before(:each) do
    @block = assign(:block, Block.create!(
      :blocker_id => "",
      :blockee_id => 1
    ))
  end

  it "renders the edit block form" do
    render

    assert_select "form[action=?][method=?]", block_path(@block), "post" do

      assert_select "input#block_blocker_id[name=?]", "block[blocker_id]"

      assert_select "input#block_blockee_id[name=?]", "block[blockee_id]"
    end
  end
end
