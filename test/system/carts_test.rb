require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  setup do
    @cart = carts(:sams)
  end

  test "visiting the index" do
    visit carts_url
    assert_selector "h1", text: "Carts"
  end

  test "should create cart" do
    visit carts_url
    click_on "New cart"

    click_on "Create Cart"

    assert_text "Cart was successfully created"
    click_on "Back"
  end

  test "should update Cart" do
    visit cart_url(@cart)
    click_on "Edit this cart", match: :first

    click_on "Update Cart"

    assert_text "Cart was successfully updated"
    click_on "Back"
  end

  test "should destroy Cart" do
    visit "/"
    click_on "Add to Cart", match: :first

    click_on "Empty Cart"

    assert_text "Your cart is currently empty"
  end
end
