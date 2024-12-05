require "test_helper"

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:sams)
  end

  test "has valid fixtures" do
    run_model_fixture_tests Cart
  end

  test "add_product builds new line item if no existing line item for product" do
    product = products(:rails_scales)
    line_item = @cart.add_product(product)
    assert_equal product.id, line_item.product_id
    assert_equal @cart.id, line_item.cart_id
    assert_equal 1, line_item.quantity
  end

  test "add_product  increments quantity if line item exist" do
    product = products(:pickaxe)
    line_item = @cart.add_product(product)
    assert_equal product.id, line_item.product_id
    assert_equal @cart.id, line_item.cart_id
    assert_equal 2, line_item.quantity
    assert_equal line_items(:sams_pickaxe).id, line_item.id
  end

  test "remove_product! destroys line item quantity is 1" do
    line_item = line_items(:sams_pickaxe)
    assert_difference("LineItem.count", -1) do
      @after_line_item = @cart.remove_product!(line_item.product)
    end
    assert @after_line_item.destroyed?
  end

  test "remove_product! decrements quantity if line item quantity is greater than 1" do
    cart = carts(:daves)
    line_item = line_items(:daves_front_end)
    assert_equal 3, line_item.quantity
    assert_no_difference("LineItem.count") do
      cart.remove_product!(line_item.product)
    end
    line_item.reload
    assert_equal 2, line_item.quantity
  end

  test "remove_product! raises ActiveRecord::RecordNotFound if product not in cart" do
    assert_raises ActiveRecord::RecordNotFound do
      @cart.remove_product!(products(:front_end))
    end
  end

  test "total_price returns expected amount" do
    assert_equal 0, Cart.new.total_price
    assert_equal 73.94, carts(:sams).total_price
    assert_equal 126.84, carts(:daves).total_price
  end
end
