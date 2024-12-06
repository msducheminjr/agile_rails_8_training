require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:daves)
  end
  test "has valid fixtures" do
    run_model_fixture_tests Order
  end

  test "order attributes must not be empty" do
    order = Order.new
    assert order.invalid?
    assert order.errors[:name].any?
    assert order.errors[:address].any?
    assert order.errors[:email].any?
    assert order.errors[:pay_type].any?
  end

  test "requires valid pay type" do
    assert_raises ArgumentError, "'Free' is not a valid pay_type" do
      @order.pay_type = "Free"
    end
    assert_raises ArgumentError, "'5' is not a valid pay_type" do
      @order.pay_type = 5
    end
    @order.pay_type = ""
    assert @order.invalid?
    assert_equal [ "is not included in the list" ], @order.errors[:pay_type]
  end

  test "add_line_items_from_cart moves line_items from cart to order" do
    cart = carts(:daves)
    assert_equal 2, cart.line_items.length
    daves_front_end = line_items(:daves_front_end)
    daves_pragprog = line_items(:daves_pragprog)
    assert_equal cart.id, daves_front_end.cart_id
    assert_equal cart.id, daves_pragprog.cart_id
    assert_nil daves_front_end.order_id
    assert_nil daves_pragprog.order_id
    assert_equal 0, @order.line_items.length
    @order.add_line_items_from_cart(cart)
    assert_equal 2, @order.line_items.length
    @order.line_items.each do |line_item|
      assert_nil line_item.cart_id
      assert_equal @order.id, line_item.order_id
      assert_includes [ daves_front_end.id, daves_pragprog.id ], line_item.id
    end
  end
end
