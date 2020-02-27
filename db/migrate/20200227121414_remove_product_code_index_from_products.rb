class RemoveProductCodeIndexFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_index :products, column: :product_code, unique: true
  end
end
