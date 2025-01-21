require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test "has valid fixtures" do
    run_model_fixture_tests User
  end

  test "user attributes must not be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:name].any?
    assert user.errors[:email_address].any?
    assert user.errors[:password].any?
  end

  test "normalizes and enforces uniqueness of email" do
    user = User.new
    user.email_address = @user.email_address
    assert user.invalid?
    assert_equal [ "has already been taken" ], user.errors[:email_address]
    user.email_address = "StatelessCodeAdmin@example.com  "
    assert user.invalid?
    assert_equal [ "has already been taken" ], user.errors[:email_address]
    @user.email_address = "AnotherEmail@examPle.com   "
    assert @user.valid?
    assert_equal "anotheremail@example.com", @user.email_address
  end

  test "enforces uniqueness of name" do
    user = User.new
    user.name = @user.name
    assert user.invalid?
    assert_equal [ "has already been taken" ], user.errors[:name]
  end

  test "cannot destroy last user" do
    failed_delete = assert_raises User::Error do
      User.destroy_all
    end
    assert_equal "Can't delete last user", failed_delete.message
  end
end
