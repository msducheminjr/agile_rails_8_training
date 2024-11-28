require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  test "has valid fixtures" do
    run_model_fixture_tests LineItem
  end

  test "total_price returns expected value" do
    assert_equal 33.95, line_items(:sams_pickaxe).total_price
    assert_equal 86.85, line_items(:daves_front_end).total_price
  end
end
