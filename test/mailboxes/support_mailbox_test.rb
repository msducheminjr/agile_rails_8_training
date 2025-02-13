require "test_helper"

class SupportMailboxTest < ActionMailbox::TestCase
  test "we create a SupportRequest when we get a support email" do
    receive_inbound_email_from_mail(
    to: "support@example.com",
    from: "chris@somewhere.net",
    subject: "Need help",
    body: "I can't figure out how to check out!!"
    )
    support_request = SupportRequest.last
    assert_equal "chris@somewhere.net", support_request.email
    assert_equal "Need help", support_request.subject
    assert_equal "I can't figure out how to check out!!", support_request.body
    assert_empty support_request.orders
  end

  test "we add most recent order when we get a support email matching an order" do
    receive_inbound_email_from_mail(
    to: "support@example.com",
    from: "sam@example.com",
    subject: "Return",
    body: "I'm not satisfied with my order"
    )
    support_request = SupportRequest.last
    assert_equal "sam@example.com", support_request.email
    assert_equal "Return", support_request.subject
    assert_equal "I'm not satisfied with my order", support_request.body
    orders = support_request.orders
    assert_equal 2, orders.length
    assert_equal orders(:sams), orders[0]
    assert_equal orders(:sams_older), orders[1]
  end
end
