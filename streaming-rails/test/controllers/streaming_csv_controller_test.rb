require "test_helper"

class StreamingCsvControllerTest < ActionDispatch::IntegrationTest
  test "should get input" do
    get streaming_csv_input_url
    assert_response :success
  end

  test "should get output" do
    get streaming_csv_output_url
    assert_response :success
  end
end
