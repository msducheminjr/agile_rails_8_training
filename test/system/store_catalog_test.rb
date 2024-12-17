require "application_system_test_case"

class StoreCatalogTest < ApplicationSystemTestCase
  test "visiting the home page" do
    visit "/"
    store_index_assertions!
  end

  test "adding first item to cart and emptying cart" do
    @first_product = Product.order(:title).first
    visit "/"
    store_index_assertions!
    click_on "Add to Cart", match: :first
    assert_selector "div h2", text: "Your Cart"
    assert_selector "div table tr.line-item-highlight td", text: @first_product.title
    click_on "Empty Cart"
    assert_text "Your cart is currently empty"
  end

  private
    def store_index_assertions!
      assert_selector "h1", text: "Your Pragmatic Catalog"
      assert_selector "h2", text: "The Pragmatic Programmer"
      assert_selector "h2", text: "Rails Scales!"
      assert_selector "h2", text: "Programming Ruby 3.3 (5th Edition)"
      assert_selector "h2", text: "Modern Front-End Development for Rails, Second Edition"
    end
end
