ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    # Run tests to ensure all fixtures are valid for a model.
    # Parameter is the class name as a constant (User, not "User")
    # Example:
    #   test "has valid fixtures" do
    #     run_model_fixture_tests User
    #   end
    #
    # Will print fixture and error message(s) upon failure
    def run_model_fixture_tests(klass_name)
      klass_name.all.each do |model_record|
        assert_predicate(
          model_record, :valid?,
          "Invalid #{klass_name} Fixture: #{model_record.inspect}\n\nErrors: #{model_record.errors.messages}"
        )
      end
    end

    def login_as(user, password = "password")
      get users_url
      post session_url, params: {
        email_address: user.email_address,
        password: password
      }
    end
    # Exectutes a block and then sleeps for a default or specified amount of time
    #
    # This is needed for an example situation where a SystemTestCase would send an
    # email and there is a race condition where the next line of code that needs
    # the email to be sent executes without the email being added to to the
    # ActionMailer::Base.deliveries array.
    #
    # @param sleep_time DEFAULT 0.05 the amount of time in seconds to sleep after
    # yielding the block
    def await_jobs(sleep_time = 0.05)
      yield
      sleep sleep_time
    end
  end
end
