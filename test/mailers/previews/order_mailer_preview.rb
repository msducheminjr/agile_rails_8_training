# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/received
  def received
    the_order = safe_order
    OrderMailer.received(the_order)
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/shipped
  def shipped
    the_order = safe_order
    OrderMailer.shipped(the_order)
  end

  private
    # create a safe order instead of reading one from the database
    def safe_order
      the_order = Order.new(
        name: "Fakey McFakerson", address: "Fakeland", email: "fake@example.com",
        pay_type: "Purchase order"
      )
      Product.take(5).each do |product|
        the_order.line_items.build(product_id: product.id, price: product.price)
      end
      the_order
    end
end
