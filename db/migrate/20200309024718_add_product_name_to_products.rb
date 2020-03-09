class AddProductNameToProducts < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :product_code, :product_name
    add_column :products, :product_code, :string, null: false, index: { unique: true }
  end
end
