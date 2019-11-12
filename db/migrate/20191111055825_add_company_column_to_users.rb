class AddCompanyColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :company, index: true, foreign_key: true
  end
end
