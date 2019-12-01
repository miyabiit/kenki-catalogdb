class CreateStoredPropSubCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :stored_prop_sub_categories do |t|
      t.references :stored_prop, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true

      t.timestamps null: false

      t.index [:stored_prop_id, :sub_category_id], unique: true, name: 'idx_uniq_stored_prop_sub_categories'
    end
  end
end
