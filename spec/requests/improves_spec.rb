require 'rails_helper'

RSpec.describe "Improves", type: :request do
  describe "GET /improves" do
    it "works! (now write some real specs)" do
      get improves_path
      expect(response).to have_http_status(200)
    end
  end
end
