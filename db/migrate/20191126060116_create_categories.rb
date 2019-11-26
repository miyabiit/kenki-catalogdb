class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.references :category, null: true, index: true
      t.references :company, null: false, index: true, foreign_key: true
      t.string :name, null: false
      t.integer :position
      t.boolean :last, default: false

      t.timestamps null: false
    end
  end
end
