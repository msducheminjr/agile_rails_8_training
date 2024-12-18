require "test_helper"

class OrderMailerTest < ActionMailer::TestCase
  setup do
    @order = orders(:sams)
  end
  test "received" do
    mail = OrderMailer.received(@order)
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal [ @order.email ], mail.to
    assert_equal [ "statelesscode@example.com" ], mail.from
    # text part
    assert_match(/1 x The Pragmatic Programmer/, mail.body.encoded)
    # html part
    assert_match %r{
      <td[^>]*>1<\/td>\s*
      <td>&times;<\/td>\s*
      <td[^>]*>\s*The\sPragmatic\sProgrammer\s*</td>
    }x, mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped(@order)
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal [ @order.email ], mail.to
    assert_equal [ "statelesscode@example.com" ], mail.from
    # text part
    assert_match(/1 x The Pragmatic Programmer/, mail.body.encoded)
    # html part
    assert_match %r{
      <td[^>]*>1<\/td>\s*
      <td>&times;<\/td>\s*
      <td[^>]*>\s*The\sPragmatic\sProgrammer\s*</td>
    }x, mail.body.encoded
  end
end
