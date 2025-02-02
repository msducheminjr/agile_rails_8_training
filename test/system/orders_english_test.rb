require "application_system_test_case"

class OrdersEnglishTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    @order = orders(:daves)
    I18n.locale = I18n.default_locale
  end
  teardown do
    I18n.locale = I18n.default_locale
  end

  test "check dynamic fields in English" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"
    assert has_no_field? "Routing #"
    assert has_no_field? "Account #"
    assert has_no_field? "CC #"
    assert has_no_field? "Expiry"
    assert has_no_field? "PO #"
    select "Check", from: "Pay with"
    assert has_field? "Routing #"
    assert has_field? "Account #"
    assert has_no_field? "CC #"
    assert has_no_field? "Expiry"
    assert has_no_field? "PO #"
    select "Credit card", from: "Pay with"
    assert has_no_field? "Routing #"
    assert has_no_field? "Account #"
    assert has_field? "CC #"
    assert has_field? "Expiry"
    assert has_no_field? "PO #"
    select "Purchase order", from: "Pay with"
    assert has_no_field? "Routing #"
    assert has_no_field? "Account #"
    assert has_no_field? "CC #"
    assert has_no_field? "Expiry"
    assert has_field? "PO #"
  end

  test "check order and delivery" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    fill_in "Name", with: "Dave Thomas"
    fill_in "Address", with: "123 Main Street"
    fill_in "Email", with: "dave@example.com"

    select "Check", from: "Pay with"
    fill_in "Routing #", with: "123456789"
    fill_in "Account #", with: "0000987654"

    click_button "Place Order"
    assert_text "Thank you for your order"

    perform_enqueued_jobs # ChargeOrderJob
    perform_enqueued_jobs # confirmation email deliver_later

    # depending on seed it might be either 2 or 3 because of broadcast jobs
    assert_operator performed_jobs.length, :>=, 2

    orders = Order.all
    assert_equal 1, orders.size
    order = orders.first

    assert_equal "Dave Thomas", order.name
    assert_equal "123 Main Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "dave@example.com" ], mail.to
    assert_equal "Stateless Code <statelesscode@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "has correct English error message translations" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    click_button "Place Order"

    assert_text "4 errors prohibited this Order from being saved."
    assert_text "There were problems with the following fields:"
    assert_text "Name can't be blank"
    assert_text "Address can't be blank"
    assert_text "Email can't be blank"
    assert_text "Pay type is not included in the list"
  end
end
