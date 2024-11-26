require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:pickaxe)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "should create product" do
    visit products_url
    click_on "New product"

    fill_in "Description", with: "Hack the Stateless Code"
    fill_in "Price", with: 23.95
    fill_in "Title", with: "Stateless Coding"
    attach_file "Image", "test/fixtures/files/stateless_logo_256.png"
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "should update Product" do
    visit product_url(@product)
    click_on "Edit this product", match: :first

    fill_in "Description", with: @product.description
    fill_in "Price", with: @product.price
    fill_in "Title", with: @product.title
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "should destroy Product" do
    visit product_url(products(:rails_scales))
    click_on "Destroy this product", match: :first

    assert_text "Product was successfully destroyed"
  end
end
