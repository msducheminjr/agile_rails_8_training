require "application_system_test_case"

class OrdersPirateTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    @order = orders(:daves)
    I18n.locale = I18n.default_locale
  end
  teardown do
    I18n.locale = I18n.default_locale
  end

  test "check dynamic fields in Pirate" do
    visit store_index_url(locale: "pirate")

    click_on "Add to Booty", match: :first

    click_on "Checkout! Arrr!"
    assert has_no_field? "Routing number for banking crew"
    assert has_no_field? "Bank account number"
    assert has_no_field? "Sixteen plastic digits"
    assert has_no_field? "Date it goes to Davy Jones' locker"
    assert has_no_field? "IOU #"
    select "Cheque", from: "Yer payment method"
    assert has_field? "Routing number for banking crew"
    assert has_field? "Bank account number"
    assert has_no_field? "Sixteen plastic digits"
    assert has_no_field? "Date it goes to Davy Jones' locker"
    assert has_no_field? "IOU #"
    select "Plastic", from: "Yer payment method"
    assert has_no_field? "Routing number for banking crew"
    assert has_no_field? "Bank account number"
    assert has_field? "Sixteen plastic digits"
    assert has_field? "Date it goes to Davy Jones' locker"
    assert has_no_field? "IOU #"
    select "IOU", from: "Yer payment method"
    assert has_no_field? "Routing number for banking crew"
    assert has_no_field? "Bank account number"
    assert has_no_field? "Sixteen plastic digits"
    assert has_no_field? "Date it goes to Davy Jones' locker"
    assert has_field? "IOU #"
  end

  test "purchase order and delivery" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url(locale: "pirate")

    click_on "Add to Booty", match: :first

    click_on "Checkout! Arrr!"

    fill_in "Name", with: "Dave Thomas"
    fill_in "Address", with: "123 Main Street"
    fill_in "E-mail", with: "dave@example.com"

    select "IOU", from: "Yer payment method"
    fill_in "IOU #", with: "555555555"

    click_button "Get Loot"
    assert_text "Thank ye for yer orrrder, matey."

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
    assert_equal "Purchase order", order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "dave@example.com" ], mail.to
    assert_equal "Stateless Code <statelesscode@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "has correct Pirate error message translations" do
    visit store_index_url(locale: "pirate")

    click_on "Add to Booty", match: :first

    click_on "Checkout! Arrr!"

    click_button "Get Loot"

    assert_text "4 errors sunk yer chance to save this orrrder."
    assert_text "There be problems with the fields below, matey:"
    assert_text "Yer name can't be blank, lest ye get a cutlass to the chest"
    assert_text "Address or Ship can't be blank, lest ye get a cutlass to the chest"
    assert_text "Yer email can't be blank, lest ye get a cutlass to the chest"
    assert_text "Yer payment method ain't included in the list, matey"
  end
end
