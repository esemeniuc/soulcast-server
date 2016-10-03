require 'test_helper'

class NearbyControllerTest < ActionDispatch::IntegrationTest
  test "should get fetch" do
    get nearby_fetch_url
    assert_response :success
  end

end
