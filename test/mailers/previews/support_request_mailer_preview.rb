# Preview all emails at http://localhost:3000/rails/mailers/support_request_mailer
class SupportRequestMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/support_request_mailer/respond
  def respond
    SupportRequestMailer.respond(mail_request)
  end

  private
    def mail_request
      support_request = SupportRequest.new(
        email: "stevethepirate@example.com",
        subject: "What be US pieces o eight?",
        body: "Matey, what be the exchange rate between normal pieces o eight" \
        "and US? Gyaaaar!"
      )
      support_request.response = %Q(
        <div>
          <p>Hi Steve,</p>
          <p>Thanks for reaching out to us. It turns out that US
              pieces o' 8 is just <strong>US dollars</strong>. If you are
              treating pieces o' 8 as one eighth of a dollar, then you would
              multiply by 8 to get your price.
          </p>
          <p>Sincerely,</p>
          <p>The Pragmatic Bookshelf</p>
        </div>
      )
      support_request
    end
end
