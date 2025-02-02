require "application_system_test_case"

class OrdersSpanishTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    @order = orders(:daves)
    I18n.locale = I18n.default_locale
  end
  teardown do
    I18n.locale = I18n.default_locale
  end

  test "check dynamic fields in Spanish" do
    visit store_index_url(locale: "es")

    click_on "Añadir al Carrito", match: :first

    click_on "Comprar"
    assert has_no_field? "# de Enrutamiento"
    assert has_no_field? "# de Cuenta"
    assert has_no_field? "Número"
    assert has_no_field? "Expiración"
    select "Cheque", from: "Forma de pago"
    assert has_field? "# de Enrutamiento"
    assert has_field? "# de Cuenta"
    assert has_no_field? "Número"
    assert has_no_field? "Expiración"
    select "Tarjeta de Crédito", from: "Forma de pago"
    assert has_no_field? "# de Enrutamiento"
    assert has_no_field? "# de Cuenta"
    assert has_field? "Número"
    assert has_field? "Expiración"
    select "Orden de Compra", from: "Forma de pago"
    assert has_no_field? "# de Enrutamiento"
    assert has_no_field? "# de Cuenta"
    assert has_no_field? "Expiración"
    assert has_field? "Número"
  end

  test "credit card order and delivery in Spanish" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url(locale: "es")

    click_on "Añadir al Carrito", match: :first

    click_on "Comprar"

    fill_in "Nombre", with: "Dave Thomas"
    fill_in "Dirección", with: "123 Main Street"
    fill_in "E-mail", with: "dave@example.com"

    select "Tarjeta de Crédito", from: "Forma de pago"
    fill_in "Número", with: "4444444444444444"
    fill_in "Expiración", with: "02/99"

    click_button "Realizar Pedido"
    assert_text "Gracias por su pedido."

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
    assert_equal "Credit card", order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "dave@example.com" ], mail.to
    assert_equal "Stateless Code <statelesscode@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "has correct Spanish error message translations" do
    visit store_index_url(locale: "es")

    click_on "Añadir al Carrito", match: :first

    click_on "Comprar"

    click_button "Realizar Pedido"

    assert_text "4 errores han impedido que este pedido se guarde."
    assert_text "Hay problemas con los siguientes campos:"
    assert_text "Nombre no puede quedar en blanco"
    assert_text "Dirección no puede quedar en blanco"
    assert_text "E-mail no puede quedar en blanco"
    assert_text "Forma de pago no está incluido en la lista"
  end
end
