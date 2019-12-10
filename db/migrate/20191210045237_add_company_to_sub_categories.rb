class AddCompanyToSubCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :sub_categories, :company, index: true, null: false, foreign_key: false
  end
end
