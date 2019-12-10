class AddCompanyToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :company, index: true, null: false, foreign_key: false
  end
end
