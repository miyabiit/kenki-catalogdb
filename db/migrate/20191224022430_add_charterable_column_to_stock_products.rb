class AddCharterableColumnToStockProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :stock_products, :charterable, :boolean, default: false
  end
end
