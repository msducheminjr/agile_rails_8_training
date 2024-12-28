require "ostruct"
class Pago
  def self.make_payment(order_id:,
                        payment_method:,
                        payment_details:)
    succeeded = true
    err = nil
    case payment_method
    when :check
      Rails.logger.info "Processing check: " +
      payment_details.fetch(:routing).to_s + "/" +
      payment_details.fetch(:account).to_s
    when :credit_card
      Rails.logger.info "Processing credit_card: " +
      payment_details.fetch(:cc_num).to_s + "/" +
      payment_details.fetch(:expiration_month).to_s + "/" +
      payment_details.fetch(:expiration_year).to_s
    when :po
      Rails.logger.info "Processing purchase order: " +
      payment_details.fetch(:po_num).to_s
    else
      succeeded = false
      err = "Unknown payment_method #{payment_method}"
    end
    # in a real, non-playtime app these types of things would be validated
    # by the model before ever getting to the payment processor
    sleep 3 unless Rails.env.test?
    if payment_method == :check && payment_details.fetch(:routing).to_s.length != 9
      succeeded = false
      err = "Invalid routing number length"
    end
    Rails.logger.info "Done Processing Payment, succeeded: #{succeeded}"
    OpenStruct.new(
      succeeded?: succeeded,
      error: err
    )
  end
end
