class AddPriceToLineItemsAndCopyFromProduct < ActiveRecord::Migration[8.0]
  def up
    add_column :line_items, :subtotal, :decimal, precision: 8, scale: 2
    # Iterate add the subtotal to each LineItem record
    # This would not scale well over a large collection of records
    LineItem.all.each do |line_item|
      line_item.subtotal = line_item.total_price
      line_item.save!
    end
  end

  def down
    remove_column :line_items, :subtotal
  end
end
