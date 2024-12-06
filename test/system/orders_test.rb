require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:daves)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "trying to create an Order with no cart redirects to the store" do
    visit new_order_url

    assert_text "Your Pragmatic Catalog"
    assert_text "Your cart is empty"
  end

  test "should create order" do
    Cart.destroy_all
    visit store_index_url
    click_on "Add to Cart", match: :first
    click_on "Checkout"

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
    select @order.pay_type, from: "Pay type"
    click_on "Place Order"

    assert_text "Thank you for your order."
    assert_text "Your Pragmatic Catalog"
  end

  test "should update Order" do
    visit order_url(@order)
    click_on "Edit this order", match: :first

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
    select "Purchase order", from: "Pay type"
    click_on "Place Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "should destroy Order" do
    visit order_url(@order)
    click_on "Destroy this order", match: :first

    assert_text "Order was successfully destroyed"
  end
end
