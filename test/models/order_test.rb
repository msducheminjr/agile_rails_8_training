require "test_helper"

class OrderTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  setup do
    @order = orders(:sams)
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
    order = orders(:daves)
    assert_equal 2, cart.line_items.length
    daves_front_end = line_items(:daves_front_end)
    daves_pragprog = line_items(:daves_pragprog)
    assert_equal cart.id, daves_front_end.cart_id
    assert_equal cart.id, daves_pragprog.cart_id
    assert_nil daves_front_end.order_id
    assert_nil daves_pragprog.order_id
    assert_equal 0, order.line_items.length
    order.add_line_items_from_cart(cart)
    assert_equal 2, order.line_items.length
    order.line_items.each do |line_item|
      assert_nil line_item.cart_id
      assert_equal order.id, line_item.order_id
      assert_includes [ daves_front_end.id, daves_pragprog.id ], line_item.id
    end
  end

  test "charge! works for Check" do
    @order.pay_type = "Check"
    pay_type_params = { routing_number: "123456789", account_number: "00000024601001337" }
    result = @order.charge!(pay_type_params)
    assert result.succeeded?
    charge_email_assertions!
  end

  test "charge! works for Credit card" do
    # pay type is already Credit Card
    pay_type_params = { credit_card_number: "4" * 16, expiration_date: "04/29" }
    result = @order.charge!(pay_type_params)
    assert result.succeeded?
    charge_email_assertions!
  end

  test "charge! works for Purchase order" do
    @order.pay_type = "Purchase order"
    pay_type_params = { po_number: "555599955" }
    result = @order.charge!(pay_type_params)
    assert result.succeeded?
    charge_email_assertions!
  end

  test "charge! errors on bad pay type" do
    @order.pay_type = nil
    error = assert_raises StandardError do
      @order.charge!({})
    end
    assert_equal "Unknown payment_method ", error.message
  end

  private
    def charge_email_assertions!
      perform_enqueued_jobs
      assert_performed_jobs 1
      mail = ActionMailer::Base.deliveries.last
      assert_equal [ "sam@example.com" ], mail.to
      assert_equal "Stateless Code <statelesscode@example.com>", mail[:from].value
      assert_equal "Pragmatic Store Order Confirmation", mail.subject
    end
end
