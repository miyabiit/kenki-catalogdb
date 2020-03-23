class AddNameColumnsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :manufacture_name, :string
    add_column :products, :product_model_name, :string
    add_column :products, :product_short_name, :string
  end
end
