class CreateStockProductStoredProps < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_product_stored_props do |t|
      t.references :stock_product, null: false, foreign_key: true
      t.references :stored_prop, null: false, polymorphic: true, index: false, foreign_key: false

      t.boolean :published, default: false
      t.boolean :charterable, default: false

      t.index [:stock_product_id, :stored_prop_type, :stored_prop_id], unique: true, name: 'idx_uniq_on_stock_product_stored_props'
    end
  end
end
