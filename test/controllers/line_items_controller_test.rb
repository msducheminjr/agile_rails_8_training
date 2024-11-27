require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:sams_pragprog)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
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

    assert_redirected_to cart_url(LineItem.last.cart_id)

    follow_redirect!

    assert_select "h2", "Your Pragmatic Cart"
    assert_select "li", "1 \u00D7 The Pragmatic Programmer"
    assert_no_difference("Cart.count") do
      assert_no_difference("LineItem.count") do
        post line_items_url, params: { product_id: products(:pragprog).id }
      end
    end
    follow_redirect!

    assert_select "h2", "Your Pragmatic Cart"
    assert_select "li", "2 \u00D7 The Pragmatic Programmer"
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to line_items_url
  end
end