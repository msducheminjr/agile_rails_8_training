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

  test "paid with methods return expected values" do
    # initial state
    assert @order.paid_with_check?
    assert_not @order.paid_with_card?
    assert_not @order.paid_with_purchase_order?

    # change to credit card
    @order.pay_type = "Credit card"
    assert_not @order.paid_with_check?
    assert @order.paid_with_card?
    assert_not @order.paid_with_purchase_order?

    # change to purchase order
    @order.pay_type = "Purchase order"
    assert_not @order.paid_with_check?
    assert_not @order.paid_with_card?
    assert @order.paid_with_purchase_order?

    # change to nil
    @order.pay_type = nil
    assert_not @order.paid_with_check?
    assert_not @order.paid_with_card?
    assert_not @order.paid_with_purchase_order?
  end

  test "validates dynamic payment method fields" do
    # start with nil
    nil_out_order_pay_fields(@order)
    assert @order.invalid?
    assert @order.errors[:pay_type].any?
    assert_not @order.errors[:routing_number].any?
    assert_not @order.errors[:account_number].any?
    assert_not @order.errors[:credit_card_number].any?
    assert_not @order.errors[:expiration_date].any?
    assert_not @order.errors[:po_number].any?

    # check
    @order.pay_type = "Check"
    assert @order.invalid?
    assert_not @order.errors[:pay_type].any?
    assert @order.errors[:routing_number].any?
    assert @order.errors[:account_number].any?
    assert_not @order.errors[:credit_card_number].any?
    assert_not @order.errors[:expiration_date].any?
    assert_not @order.errors[:po_number].any?
    @order.routing_number = "222222222"
    @order.account_number = "0000123456789"
    assert @order.valid?
    nil_out_order_pay_fields(@order)

    # credit card
    @order.pay_type = "Credit card"
    assert @order.invalid?
    assert_not @order.errors[:pay_type].any?
    assert_not @order.errors[:routing_number].any?
    assert_not @order.errors[:account_number].any?
    assert @order.errors[:credit_card_number].any?
    assert @order.errors[:expiration_date].any?
    assert_not @order.errors[:po_number].any?
    @order.credit_card_number = "5555444433332222"
    @order.expiration_date = "02/27"
    assert @order.valid?
    nil_out_order_pay_fields(@order)

    # purchase order
    @order.pay_type = "Purchase order"
    assert @order.invalid?
    assert_not @order.errors[:pay_type].any?
    assert_not @order.errors[:routing_number].any?
    assert_not @order.errors[:account_number].any?
    assert_not @order.errors[:credit_card_number].any?
    assert_not @order.errors[:expiration_date].any?
    assert @order.errors[:po_number].any?
    @order.po_number = "1337"
    assert @order.valid?
  end

  private
    def nil_out_order_pay_fields(order)
      order.pay_type = nil
      order.routing_number = nil
      order.account_number = nil
      order.credit_card_number = nil
      order.expiration_date = nil
      order.po_number = nil
    end
end
