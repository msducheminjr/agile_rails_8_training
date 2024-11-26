require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select "nav a", minimum: 4
    assert_select "main ul li", 4
    assert_select "h2", "The Pragmatic Programmer"
    assert_select "div", /\$[,\d]+\.\d\d/
    assert_select "p", "You have visited this page 1 time."

    get store_index_url
    assert_select "p", "You have visited this page 2 times."
  end
end
