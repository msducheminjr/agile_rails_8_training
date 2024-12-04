require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  setup do
    @cart = carts(:sams)
  end

  test "visiting the index" do
    visit carts_url
    assert_selector "h1", text: "Carts"
  end

  test "should not allow cart creation via UI" do
    visit carts_url
    click_on "New cart"

    click_on "Create Cart"

    assert_text "Invalid cart"
    assert_selector "h1", text: "Your Pragmatic Catalog"
  end

  test "should not allow updating Cart" do
    visit edit_cart_url(@cart)

    assert_text "Invalid cart"
    assert_selector "h1", text: "Your Pragmatic Catalog"
  end

  test "should destroy Cart" do
    visit "/"
    click_on "Add to Cart", match: :first

    click_on "Empty Cart"

    assert_text "Your cart is currently empty"
  end
end
