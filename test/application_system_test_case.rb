require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  def browser_login_as(user, the_password = "password")
    visit new_session_url
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: the_password
    await_jobs 0.4 do
      click_on "Sign in"
    end

    assert_no_text "Try another email address or password."
  end
end
