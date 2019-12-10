class AddCompanyToStoredProps < ActiveRecord::Migration[6.0]
  def change
    add_reference :stored_props, :company, index: true, null: false, foreign_key: false
  end
end
