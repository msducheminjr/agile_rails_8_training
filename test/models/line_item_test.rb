require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  test "has valid fixtures" do
    run_model_fixture_tests LineItem
  end

  test "total_price returns expected value" do
    assert_equal 33.95, line_items(:sams_pickaxe).total_price
    assert_equal 86.85, line_items(:daves_front_end).total_price
  end

  test "total_price does not change if product price changes" do
    single_line_item = line_items(:sams_pickaxe)
    multi_line_item = line_items(:daves_front_end)
    assert_equal 33.95, single_line_item.total_price
    assert_equal 86.85, multi_line_item.total_price
    products(:pickaxe).update!(price: 20.59)
    products(:front_end).update(price: 100.99)
    assert_equal 33.95, single_line_item.reload.total_price
    assert_equal 86.85, multi_line_item.reload.total_price
  end
end
