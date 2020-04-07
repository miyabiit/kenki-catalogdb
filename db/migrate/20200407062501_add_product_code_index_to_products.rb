class AddProductCodeIndexToProducts < ActiveRecord::Migration[6.0]
  def change
    add_index :products, :product_code, unique: true
  end
end
