class AddUniqueIndexToCategories < ActiveRecord::Migration[6.0]
  def change
    add_index :categories, [:company_id, :name], unique: true
  end
end
