require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users(:one)
    @pw = "password"
    @safe_flash = "Password reset instructions sent (if user with that email address exists)."
    @new_pw = "Th1sI$MyN3w1"
    @token_regex = /\/passwords\/(\w|-)+\/edit/
  end

  test "redirects back to original page with valid credentials" do
    get products_url
    assert_redirected_to new_session_url
    assert_equal "You must login first.", flash[:notice]

    assert_difference("Session.count") do
      post session_url, params: {
        # test email normalization at the login level
        email_address: "  #{@user.email_address.upcase} ", password: @pw
      }
    end

    assert_redirected_to products_url
  end

  test "can reset password and login" do
    get new_session_url
    assert_response :success
    post passwords_url, params: { email_address: @user.email_address }

    assert_redirected_to new_session_url
    assert_equal @safe_flash, flash[:notice]

    # test appropriate email
    perform_enqueued_jobs
    assert_performed_jobs 1
    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "statelesscodeadmin@example.com" ], mail.to
    assert_equal "Stateless Code <statelesscode@example.com>", mail[:from].value
    assert_equal "Reset your password", mail.subject

    # get token from email and assert pattern matching
    assert_match(@token_regex, mail.html_part.encoded)
    assert_match(@token_regex, mail.text_part.encoded)
    reset_token = mail.html_part.encoded.match(@token_regex)[0][11..-6]

    # visit edit password with emailed token
    get edit_password_url(reset_token)
    assert_response :success

    # update to new password
    patch password_url(reset_token), params: { password: @new_pw, password_confirmation: @new_pw }

    assert_redirected_to new_session_url
    assert_equal "Password has been reset.", flash[:notice]

    assert_difference("Session.count") do
      post session_url, params: {
        email_address: @user.email_address, password: @new_pw
      }
    end

    assert_redirected_to admin_url
    the_session = Session.last
    assert_equal @user.id, the_session.user_id
  end

  test "can log in, out, and back in" do
    # login
    assert_difference("Session.count") do
      post session_url, params: {
        email_address: @user.email_address, password: @pw
      }
    end

    assert_redirected_to admin_url
    first_session = Session.last
    assert_equal @user.id, first_session.user_id
    assert_equal 1, @user.reload.sessions.count

    # logout
    assert_difference("Session.count", -1) do
      delete session_url
    end

    assert_redirected_to new_session_url
    assert_nil flash[:alert]
    assert_equal "You have successfully logged out.", flash[:notice]
    assert_equal 0, @user.reload.sessions.count

    # log back in
    assert_difference("Session.count") do
      post session_url, params: {
        email_address: @user.email_address, password: @pw
      }
    end

    assert_redirected_to admin_url
    second_session = Session.last
    assert_equal @user.id, second_session.user_id
    assert_not_equal first_session.id, second_session.id
    assert_equal 1, @user.reload.sessions.count
  end
end
