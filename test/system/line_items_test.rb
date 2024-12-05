require "application_system_test_case"

class LineItemsTest < ApplicationSystemTestCase
  setup do
    @line_item = line_items(:daves_pragprog)
    # to ensure the cart from the session is reset
    Cart.where.not(id: @line_item.cart_id).destroy_all
  end

  test "visiting the index" do
    visit line_items_url
    assert_selector "h1", text: "Line items"
  end

  test "should update Line item" do
    visit line_item_url(@line_item)
    click_on "Edit this line item", match: :first

    fill_in "Cart", with: @line_item.cart_id
    fill_in "Product", with: @line_item.product_id
    click_on "Update Line item"

    assert_text "Line item was successfully updated"
    click_on "Back"
  end

  test "should reduce Line item quantity or remove" do
    visit "/"
    click_on "Add to Cart", match: :first
    click_on "Add to Cart", match: :first
    # add second item to cart
    find(:xpath, "/html/body/section/main/div/ul/turbo-frame[2]/li/div/div/form/button").click

    # remove the product with one line item
    click_on "Remove"

    assert_text "Programming Ruby 3.3 (5th Edition) was successfully removed"

    # decrease front_end from 2 to 1
    click_on "Decrease"

    assert_text "Quantity of Modern Front-End Development for Rails, Second Edition was successfully decreased"

    # remove front_end
    click_on "Remove"

    assert_text "Your cart is currently empty"
  end
end
