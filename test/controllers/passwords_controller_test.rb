class PasswordsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users(:one)
    @pw = "password"
    @safe_flash = "Password reset instructions sent (if user with that email address exists)."
    @bad_token_message = "Password reset link is invalid or has expired."
    @bogus_token = "I'mfromthegovernmentI'mheretohelp"
    @new_pw = "Th1sI$MyN3w1"
  end

  test "should get new" do
    get new_password_url
    assert_response :success
  end

  test "should send email if user email matches a valid user" do
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
  end

  test "should not send email for non-existing user" do
    post passwords_url, params: { email_address: "fake@example.com" }

    assert_redirected_to new_session_url
    assert_equal @safe_flash, flash[:notice]

    # test appropriate email
    perform_enqueued_jobs
    assert_no_performed_jobs
  end

  test "should get edit with valid token" do
    token = @user.password_reset_token

    get edit_password_url(token)

    assert_response :success
  end

  test "should not allow invalid token for edit" do
    get edit_password_url(@bogus_token)

    assert_redirected_to new_password_url
    assert_equal @bad_token_message, flash[:alert]
  end

  test "should not allow epired token for edit" do
    token = @user.password_reset_token

    travel_to 16.minutes.from_now do
      get edit_password_url(token)
    end

    assert_redirected_to new_password_url
    assert_equal @bad_token_message, flash[:alert]
  end

  test "should update password with valid token and matching passwords" do
    token = @user.password_reset_token

    patch password_url(token), params: { password: @new_pw, password_confirmation: @new_pw }

    assert_redirected_to new_session_url
    assert_equal "Password has been reset.", flash[:notice]
  end

  test "should not update password with valid token and mismatching passwords" do
    token = @user.password_reset_token

    patch password_url(token), params: { password: @new_pw, password_confirmation: "mismatch" }

    assert_redirected_to edit_password_url(token)
    assert_equal "Passwords did not match.", flash[:alert]
  end

  test "should not update with invalid token" do
    patch password_url(@bogus_token), params: { password: @new_pw, password_confirmation: @new_pw }

    assert_redirected_to new_password_url
    assert_equal @bad_token_message, flash[:alert]
  end

  test "should not update with expired token" do
    token = @user.password_reset_token

    travel_to 16.minutes.from_now do
      patch password_url(token), params: { password: @new_pw, password_confirmation: @new_pw }
    end
    assert_redirected_to new_password_url
    assert_equal @bad_token_message, flash[:alert]
  end
end
