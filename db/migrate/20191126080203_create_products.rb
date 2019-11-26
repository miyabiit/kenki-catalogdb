class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :product_code, null: false, index: { unique: true }
      t.references :category, null: false, index: true, foreign_key: true
      t.string :title, null: false
      t.boolean :netis, default: false
      t.date :netis_limit_date
      t.boolean :qualification_sp_teach, default: false
      t.boolean :qualification_skill, default: false
      t.text :qualification_comment
      t.boolean :driver_license, default: false
      t.boolean :checking_teiji, default: false
      t.boolean :checking_tokujiken, default: false
      t.boolean :checking_shaken, default: false
      t.boolean :checking_denhou, default: false
      t.boolean :checking_souken, default: false
      t.text :description_a
      t.text :description_b
      t.string :video_url
      t.text :video_comment
      t.text :video_license_memo

      t.timestamps null: false
    end
  end
end
