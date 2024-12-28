require "test_helper"
require "./test/mailers/previews/error_mailer_preview"

class ErrorMailerTest < ActionMailer::TestCase
  test "invalid_cart" do
    the_time = Time.current
    mail = ErrorMailer.invalid_cart(
      ErrorMailerPreview::ERROR_MAILER_HASH,
      the_time
    )
    assert_equal "Invalid cart params access attempt", mail.subject
    assert_equal [ "error-monitoring@statelesscode.example.com" ], mail.to
    assert_equal [ "statelesscode@example.com" ], mail.from
    assert_match(
      /An invalid attempt was made to access a cart that did not belong to the user\./,
      mail.body.encoded
    )
    assert_match(
      /Examine the nature of the error and ensure attack vectors are adequately defended\./,
      mail.body.encoded
    )
    assert_match(/#{the_time}/, mail.body.encoded)
    # text part
    assert_match(/Request\sMethod\:\sDELETE/, mail.body.encoded)
    # html part
    assert_match %r{
      <dt[^>]*>action\:<\/dt>\s*
      <dd>delete<\/dd>\s*
    }x, mail.body.encoded
  end

  test "pago failure" do
    order = orders(:daves)
    mail = ErrorMailer.pago_failure(order, "Something went wrong")
    assert_equal "Pago processing error occurred", mail.subject
    assert_equal [ "error-monitoring@statelesscode.example.com" ], mail.to
    assert_equal [ "statelesscode@example.com" ], mail.from
    assert_match(
      /Error occurred when trying to charge Pago for order ID #{order.id}\./,
      mail.body.encoded
    )
    assert_match(
      /Error\: Something went wrong/,
      mail.body.encoded
    )
  end
end
