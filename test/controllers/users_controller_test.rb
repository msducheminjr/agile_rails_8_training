require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    login_as @user
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email_address: "new_user@example.com", name: "newuser", password: "secret", password_confirmation: "secret" } }
    end

    assert_redirected_to users_url
    assert_equal "User newuser was successfully created.", flash[:notice]
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email_address: @user.email_address, name: @user.name, password: "secret", password_confirmation: "secret" } }
    assert_redirected_to users_url
    assert_equal "User StatelessCode was successfully updated.", flash[:notice]
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end

  test "should not destroy last user" do
    User.where.not(id: @user.id).destroy_all
    assert_no_difference("User.count") do
      delete user_url(@user)
    end

    assert_redirected_to users_url
    assert_equal "Can't delete last user", flash[:notice]
  end
end
