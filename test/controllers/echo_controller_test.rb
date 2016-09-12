require 'test_helper'

class EchoControllerTest < ActionDispatch::IntegrationTest
  test "should get reply" do
    get echo_reply_url
    assert_response :success
  end

end
