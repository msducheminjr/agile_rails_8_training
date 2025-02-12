require "test_helper"

class SupportRequestMailerTest < ActionMailer::TestCase
  test "respond" do
    @support_request = support_requests(:steves)
    mail = SupportRequestMailer.respond(@support_request)
    assert_equal "Re: #{@support_request.subject}", mail.subject
    assert_equal [ @support_request.email ], mail.to
    assert_equal [ "support@example.com" ], mail.from
    # html version
    assert_match "<div><p>Hi Steve,</p>", mail.body.encoded
    # text version
    assert_match "\r\nHi Steve,\r\n", mail.body.encoded
  end
end
