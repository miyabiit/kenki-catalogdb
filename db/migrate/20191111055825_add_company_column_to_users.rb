class AddCompanyColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :company, null: false, index: true, foreign_key: true
  end
end
