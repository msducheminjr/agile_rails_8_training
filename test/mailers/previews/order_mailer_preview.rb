require "./test/mailers/previews/concerns/preview_orderable"

# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  include PreviewOrderable
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
end
