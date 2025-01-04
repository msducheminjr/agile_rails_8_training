require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    browser_login_as @user
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    browser_login_as @user
    visit users_url
    click_on "New user"

    fill_in "Email address", with: "newuser@example.com"
    fill_in "Name", with: "newuser"
    fill_in "Password", with: "secret"
    fill_in "Password confirmation", with: "secret"
    click_on "Create User"

    assert_text "User newuser was successfully created"
  end

  test "should update User" do
    browser_login_as @user
    user = users(:sam)
    visit user_url(user)
    click_on "Edit this user", match: :first

    fill_in "Email address", with: user.email_address
    fill_in "Name", with: user.name
    fill_in "Password", with: "secret"
    fill_in "Password confirmation", with: "secret"
    click_on "Update User"

    assert_text "User Sam Ruby was successfully updated"
  end

  test "should destroy User" do
    browser_login_as @user
    visit user_url(users(:sam))
    click_on "Destroy this user", match: :first

    assert_text "User was successfully destroyed"
  end
end
