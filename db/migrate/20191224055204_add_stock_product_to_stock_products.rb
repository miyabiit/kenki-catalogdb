class AddStockProductToStockProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :stock_products, :stock_product, null: true, index: true, foreign_key: true
  end
end
