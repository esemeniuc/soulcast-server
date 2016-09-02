require 'test_helper'

class SoulsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @soul = souls(:one)
  end

  test "should get index" do
    get souls_url
    assert_response :success
  end

  test "should get new" do
    get new_soul_url
    assert_response :success
  end

  test "should create soul" do
    assert_difference('Soul.count') do
      post souls_url, params: { soul: { device_id: @soul.device_id, epoch: @soul.epoch, latitude: @soul.latitude, longitude: @soul.longitude, radius: @soul.radius, s3Key: @soul.s3Key, soulType: @soul.soulType, token: @soul.token } }
    end

    assert_redirected_to soul_url(Soul.last)
  end

  test "should show soul" do
    get soul_url(@soul)
    assert_response :success
  end

  test "should get edit" do
    get edit_soul_url(@soul)
    assert_response :success
  end

  test "should update soul" do
    patch soul_url(@soul), params: { soul: { device_id: @soul.device_id, epoch: @soul.epoch, latitude: @soul.latitude, longitude: @soul.longitude, radius: @soul.radius, s3Key: @soul.s3Key, soulType: @soul.soulType, token: @soul.token } }
    assert_redirected_to soul_url(@soul)
  end

  test "should destroy soul" do
    assert_difference('Soul.count', -1) do
      delete soul_url(@soul)
    end

    assert_redirected_to souls_url
  end
end
