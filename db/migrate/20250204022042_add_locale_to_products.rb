class AddLocaleToProducts < ActiveRecord::Migration[8.0]
  def up
    add_column :products, :locale, :integer, default: 0
    add_index :products, :locale
  end

  def down
    products = Product.where.not(locale: 0)
    LineItem.where(product_id: products).destroy_all
    products.destroy_all

    remove_index :products, :locale
    remove_column :products, :locale
  end
end
