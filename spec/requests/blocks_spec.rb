require 'rails_helper'

RSpec.describe "Blocks", type: :request do
  describe "GET /blocks" do
    it "works! (now write some real specs)" do
      get blocks_path
      expect(response).to have_http_status(200)
    end
  end
end
