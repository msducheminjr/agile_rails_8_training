class SupportMailbox < ApplicationMailbox
  def process
    email = mail.from_address.to_s
    orders = Order.where(email: email).order(created_at: :desc)

    support_request = SupportRequest.new(
      email: email,
      subject: mail.subject,
      body: mail.body.to_s
    )
    support_request.orders = orders
    support_request.save!
  end
end
