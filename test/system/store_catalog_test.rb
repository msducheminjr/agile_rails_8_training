require "application_system_test_case"

class StoreCatalogTest < ApplicationSystemTestCase
  test "visiting the home page" do
    visit "/"
    store_index_assertions!
  end

  test "adding firt item to cart" do
    @first_product = Product.order(:title).first
    visit "/"
    store_index_assertions!
    add_first_item_to_cart
    assert_selector "div h2", text: "Your Pragmatic Cart"
    assert_selector "div ul li", text: @first_product.title
  end

  private
    def store_index_assertions!
      assert_selector "h1", text: "Your Pragmatic Catalog"
      assert_selector "h2", text: "The Pragmatic Programmer"
      assert_selector "h2", text: "Rails Scales!"
      assert_selector "h2", text: "Programming Ruby 3.3 (5th Edition)"
      assert_selector "h2", text: "Modern Front-End Development for Rails, Second Edition"
    end

    def add_first_item_to_cart
      # TODO make this better
      within(:xpath, "/html/body/section/main/div/ul/li[1]") do
        click_on "Add to Cart"
      end
    end
end
