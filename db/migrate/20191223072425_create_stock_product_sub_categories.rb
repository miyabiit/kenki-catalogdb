class CreateStockProductSubCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_product_sub_categories do |t|
      t.references :stock_product, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true

      t.timestamps null: false

      t.index [:stock_product_id, :sub_category_id], unique: true, name: 'idx_uniq_keys_on_stock_product_sub_categories'
    end
  end
end
