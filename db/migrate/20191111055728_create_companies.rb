class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :uid, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
