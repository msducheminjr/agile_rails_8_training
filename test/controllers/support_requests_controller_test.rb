require "test_helper"
require "./test/concerns/requires_authentication"

class SupportRequestsControllerTest < ActionDispatch::IntegrationTest
  include RequiresAuthentication
  setup do
    @support_request = support_requests(:daves)
    @rich_text = "<div>We will <strong>resend</strong> you the order</div>"
    @user = users(:one)
    login_as @user
  end


  test "should not allow access for public" do
    ensure_logged_out! @user

    # try the different product routes and ensure no access
    # index
    get support_requests_url
    no_access_assertions!

    # update
    patch support_request_url(@support_request), params: {
      support_request: { response: @rich_text }
    }
    no_access_assertions!
  end

  test "should get index" do
    get support_requests_url

    assert_response :success
    assert_select "ul li", minimum: 2
    assert_select "ul li h3", "Recent Order" # daves
    assert_select "ul li h4", "Our response:" # steves
  end

  test "should update response" do
    patch support_request_url(@support_request), params: {
      support_request: { response: @rich_text }
    }

    assert_redirected_to support_requests_url
    @support_request.reload
    assert_equal @rich_text, @support_request.response.body.to_html

    # email delivery assertions (uses deliver_now so no job queue interaction)
    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "dave@example.com" ], mail.to
    assert_equal "support@example.com", mail[:from].value
    assert_equal "Re: #{@support_request.subject}", mail.subject
    assert_match @rich_text, mail.body.encoded
  end
end
