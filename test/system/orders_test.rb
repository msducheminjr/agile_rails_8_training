require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:daves)
  end

  test "check dynamic fields" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"
    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "Po number"
    select "Check", from: "Pay type"
    assert has_field? "Routing number"
    assert has_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "Po number"
    select "Credit card", from: "Pay type"
    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_field? "Credit card number"
    assert has_field? "Expiration date"
    assert has_no_field? "Po number"
    select "Purchase order", from: "Pay type"
    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_field? "Po number"
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
    assert_difference "Order.count" do
      click_on "Place Order"

      assert_text "Thank you for your order."
      assert_text "Your Pragmatic Catalog"
    end
  end
end
