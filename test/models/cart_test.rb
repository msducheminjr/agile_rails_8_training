require "test_helper"

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:sams)
  end

  test "has valid fixtures" do
    run_model_fixture_tests Cart
  end

  test "builds new line item if no existing line item for product" do
    product = products(:rails_scales)
    line_item = @cart.add_product(product)
    assert_equal product.id, line_item.product_id
    assert_equal @cart.id, line_item.cart_id
    assert_equal 1, line_item.quantity
  end

  test "increments quantity if line item exist" do
    product = products(:pickaxe)
    line_item = @cart.add_product(product)
    assert_equal product.id, line_item.product_id
    assert_equal @cart.id, line_item.cart_id
    assert_equal 2, line_item.quantity
    assert_equal line_items(:sams_pickaxe).id, line_item.id
  end
end
