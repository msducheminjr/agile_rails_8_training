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

  # remove temp files created by tests for ActiveStorage
  def remove_uploaded_files
    temp_dir = "#{Rails.root}/tmp/storage"
    FileUtils.rm_rf(temp_dir)
    # maintain the .keep file so it doesn't show up as deleted in Git
    FileUtils.mkdir(temp_dir) unless Dir.exist?(temp_dir)
    FileUtils.touch("#{temp_dir}/.keep")
  end

  def after_teardown
    super
    remove_uploaded_files
  end
end
