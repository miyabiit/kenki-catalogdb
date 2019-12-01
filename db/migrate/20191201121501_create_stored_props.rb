class CreateStoredProps < ActiveRecord::Migration[6.0]
  def change
    create_table :stored_props do |t|
      t.string :name

      t.timestamps null: false 
    end
  end
end
