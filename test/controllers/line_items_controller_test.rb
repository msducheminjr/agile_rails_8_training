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

    assert_redirected_to store_index_url

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
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should not destroy line_item for another cart" do
    assert_no_difference("LineItem.count") do
      delete line_item_url(@line_item)
    end

    assert_redirected_to store_index_url
    assert_equal "Invalid cart or line item", flash[:notice]
  end

  test "should remove line item if quantity is one and have appropriate message" do
    add_the_products
    cart = Cart.last
    line_item = cart.line_items.find_by(product: products(:pragprog))
    assert_difference("LineItem.count", -1) do
      delete line_item_url(line_item)
    end

    assert_redirected_to store_index_url
    assert_equal "The Pragmatic Programmer was successfully removed", flash[:notice]
  end

  test "should decrease line item quantity if greater than one and have appropriate message" do
    add_the_products
    cart = Cart.last
    line_item = cart.line_items.find_by(product: products(:pickaxe))
    assert_equal 2, line_item.quantity
    assert_no_difference("LineItem.count") do
      delete line_item_url(line_item)
    end

    assert_equal 1, line_item.reload.quantity
    assert_redirected_to store_index_url
    assert_equal "Quantity of Programming Ruby 3.3 (5th Edition) was successfully decreased", flash[:notice]
  end

  test "should decrease line item quantity for last book with appropriate message" do
    pragprog = products(:pragprog)
    post line_items_url, params: { product_id: pragprog.id }
    cart = Cart.last
    line_item = cart.line_items.find_by(product: pragprog)
    assert_difference("LineItem.count", -1) do
      delete line_item_url(line_item)
    end

    assert_redirected_to store_index_url
    assert_equal "Your cart is currently empty", flash[:notice]
  end

  private
    def add_the_products
      pragprog = products(:pragprog)
      pickaxe = products(:pickaxe)
      post line_items_url, params: { product_id: pragprog.id }
      2.times do
        post line_items_url, params: { product_id: pickaxe.id }
      end
    end
end
