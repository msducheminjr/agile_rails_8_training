class AddOrderAndPriceToLineItem < ActiveRecord::Migration[8.0]
  def up
    add_reference :line_items, :order, null: true, foreign_key: true
    add_column :line_items, :price, :decimal, precision: 8, scale: 2
    change_column :line_items, :cart_id, :integer, null: true

    LineItem.all.each do |li|
      li.price = li.product.price
      li.save!
    end
  end

  def down
    remove_reference :line_items, :order
    remove_column :line_items, :price
    change_column :line_items, :cart_id, :integer, null: false
  end
end
