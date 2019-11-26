class CreateProductSubCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :product_sub_categories do |t|
      t.references :product, null: false, index: true, foreign_key: true
      t.references :sub_category, null: false, index: true, foreign_key: true

      t.timestamps null: false

      t.index [:product_id, :sub_category_id], unique: true
    end
  end
end
