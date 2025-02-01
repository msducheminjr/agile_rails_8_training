require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:sams_pragprog)
  end

  test "should get index" do
    login_as users(:sam)
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    login_as users(:sam)
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    # no existing cart in session, so will also create cart
    assert_difference("Cart.count") do
      assert_difference("LineItem.count") do
        post line_items_url, params: { product_id: products(:pragprog).id }
      end
    end

    assert_redirected_to store_index_url(locale: I18n.locale)

    follow_redirect!

    assert_select "h2", "Your Cart"
    assert_select "td", "The Pragmatic Programmer"
    assert_select "td", "$39.99"
    assert_no_difference("Cart.count") do
      assert_no_difference("LineItem.count") do
        post line_items_url, params: { product_id: products(:pragprog).id }
      end
    end
    follow_redirect!

    assert_select "h2", "Your Cart"
    assert_select "td", "The Pragmatic Programmer"
    assert_select "td", "$79.98"
  end

  test "should create line_item via turbo-stream" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:pragprog).id },
        as: :turbo_stream
    end
    assert_response :success
    assert_match(/<tr class="line-item-highlight">/, @response.body)
  end

  test "should show line_item" do
    login_as users(:sam)
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    login_as users(:sam)
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    login_as users(:sam)
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item, locale: I18n.locale)
  end

  test "should destroy line_item" do
    login_as users(:sam)
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to line_items_url(locale: I18n.locale)
  end
end
