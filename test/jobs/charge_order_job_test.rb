require "test_helper"

class ChargeOrderJobTest < ActiveJob::TestCase
  setup do
    @order = orders(:sams)
  end
  test "sends email to order recipient on success" do
    perform_enqueued_jobs do
      ChargeOrderJob.perform_later(@order, { credit_card_number: "4" * 16, expiration_date: "04/29" })
    end
    assert_performed_jobs 2 # job itself and the email
    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "sam@example.com" ], mail.to
    assert_equal "Stateless Code <statelesscode@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end
