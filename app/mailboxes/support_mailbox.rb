class SupportMailbox < ApplicationMailbox
  def process
    email = mail.from_address.to_s
    recent_order = Order.where(email: email).
                        order("created_at desc").
                        first
    SupportRequest.create!(
      email: email,
      subject: mail.subject,
      body: mail.body.to_s,
      order: recent_order
    )
  end
end
