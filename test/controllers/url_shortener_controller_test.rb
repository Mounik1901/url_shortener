require 'test_helper'

class UrlShortenerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get url_shortener_index_url
    assert_response :success
  end

end
