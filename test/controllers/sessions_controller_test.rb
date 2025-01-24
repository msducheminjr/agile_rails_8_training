class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @pw = "password"
  end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "can login with valid credentials" do
    assert_difference("Session.count") do
      post session_url, params: {
        email_address: @user.email_address, password: @pw
      }
    end

    assert_redirected_to admin_url
    the_session = Session.last
    assert_equal @user.id, the_session.user_id
  end

  test "cannot login with bad credentials" do
    assert_no_difference("Session.count") do
      post session_url, params: {
        email_address: @user.email_address, password: "BOGUS"
      }
    end

    assert_redirected_to new_session_url
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "can logout if authenticated" do
    post session_url params: {
      email_address: @user.email_address, password: @pw
    }

    assert_difference("Session.count", -1) do
      delete session_url
    end

    assert_redirected_to new_session_url
    assert_nil flash[:alert]
    assert_equal "You have successfully logged out.", flash[:notice]
    assert_equal '"cache","storage"', @response.headers["Clear-Site-Data"]
  end

  test "cannot logout unless authenticated" do
    assert_no_difference("Session.count") do
      delete session_url
    end

    assert_redirected_to new_session_url
    assert_equal "You must login first.", flash[:notice]
  end
end
