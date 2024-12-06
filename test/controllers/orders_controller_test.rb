require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:daves)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "requires item in cart" do
    get new_order_url

    assert_redirected_to store_index_path
    assert_equal "Your cart is empty", flash[:notice]
  end

  test "should get new" do
    post line_items_url, params: { product_id: products(:pragprog).id }

    get new_order_url
    assert_response :success
  end

  test "should create order" do
    post line_items_url, params: { product_id: products(:pragprog).id }
    post line_items_url, params: { product_id: products(:pickaxe).id }
    assert_difference("Order.count") do
      assert_difference("Cart.count", -1) do
        assert_no_difference("LineItem.count") do
          post orders_url, params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
        end
      end
    end

    assert_redirected_to store_index_url
    assert_equal "Thank you for your order.", flash[:notice]
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
