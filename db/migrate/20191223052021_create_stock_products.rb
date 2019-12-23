class CreateStockProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_products do |t|
      t.references :product, null: false, index: true, foreign_key: true
      t.references :company, null: false, index: true, foreign_key: true
      t.references :category, null: true, index: true
      t.string :video_url
      t.text :video_comment
      t.text :video_license
      t.boolean :video_license_valid, default: false
      t.boolean :video_published, default: false
      t.boolean :video_charterable, default: false
      t.text :spec
      t.text :spec_comment
      t.text :staff_comment
      t.boolean :staff_comment_published, default: false
      t.boolean :staff_comment_charterable, default: false
      t.text :price_info
      t.boolean :price_info_published, default: false
      t.boolean :price_info_charterable, default: false
      t.text :faq
      t.boolean :faq_published, default: false
      t.boolean :faq_charterable, default: false
      t.text :description
      t.boolean :description_published, default: false
      t.boolean :description_charterable, default: false
      t.text :address_info
      t.boolean :address_info_published, default: false
      t.boolean :address_info_charterable, default: false
      t.text :company_memo
      t.text :private_memo
      t.text :meta_description
      t.text :meta_keywords

      t.timestamps null: false
    end
  end
end
