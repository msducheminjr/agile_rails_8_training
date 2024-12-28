class ErrorMailer < ApplicationMailer
  default to: "error-monitoring@statelesscode.example.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_mailer.invalid_cart.subject
  #
  def invalid_cart(request_hash, infraction_time)
    @req = request_hash
    @req_time = infraction_time

    mail subject: "Invalid cart params access attempt"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_mailer.pago_failure.subject
  #
  def pago_failure(order, error)
    @order = order
    @error = error
    mail subject: "Pago processing error occurred"
  end
end
