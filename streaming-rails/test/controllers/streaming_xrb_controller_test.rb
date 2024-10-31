require "test_helper"

class StreamingXrbControllerTest < ActionDispatch::IntegrationTest
  test "should get beer" do
    get streaming_xrb_beer_url
    assert_response :success
  end
end
