require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  setup do
    @cart = carts(:sams)
  end

  test "should get index" do
    get carts_url
    assert_response :success
  end

  test "should get new" do
    get new_cart_url
    assert_response :success
  end

  test "should create cart" do
    assert_difference("Cart.count") do
      post carts_url, params: { cart: {} }
    end

    assert_redirected_to cart_url(Cart.last)
  end

  test "should show cart" do
    get cart_url(@cart)
    assert_response :success
  end

  test "should redirect to catalog if invalid cart" do
    get cart_url("notarealid")
    assert_redirected_to store_index_url
    assert_equal "Invalid cart", flash[:notice]
  end

  test "should get edit" do
    get edit_cart_url(@cart)
    assert_response :success
  end

  test "should update cart" do
    patch cart_url(@cart), params: { cart: {} }
    assert_redirected_to cart_url(@cart)
  end

  test "should destroy cart" do
    post line_items_url, params: { product_id: products(:pragprog).id }
    @cart = Cart.find(session[:cart_id])
    assert_difference("Cart.count", -1) do
      delete cart_url(@cart)
    end

    assert_redirected_to store_index_url
    assert_equal "Your cart is currently empty", flash[:notice]
  end

  test "should fail to destroy another user's cart" do
    assert_no_difference("Cart.count") do
      delete cart_url(@cart)
    end

    assert_redirected_to store_index_url
    assert_equal "Invalid cart", flash[:notice]

    perform_enqueued_jobs
    assert_performed_jobs 1
    mail = ActionMailer::Base.deliveries.last
    assert_equal "Invalid cart params access attempt", mail.subject
    assert_equal [ "error-monitoring@statelesscode.example.com" ], mail.to
    assert_equal [ "statelesscode@example.com" ], mail.from
  end
end
