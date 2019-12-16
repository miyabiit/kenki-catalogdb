class RemoveCompanyColumnsFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :products, :company, null: false, index: true, foreign_key: false
    remove_reference :products, :category, null: false, index: true, foreign_key: false
    remove_column :products, :video_url, :string
    remove_column :products, :video_comment, :text
    remove_column :products, :video_license_memo, :text
  end
end
