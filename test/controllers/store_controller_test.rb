require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select "nav a", minimum: 4
    assert_select "main ul li", 4
    assert_select "h2", "The Pragmatic Programmer"
    assert_select "div", /\$[,\d]+\.\d\d/
    assert_no_match "You have visited this page", response.body

    5.times do
      get store_index_url
    end
    assert_select "p", "You have visited this page 6 times."
  end
end
