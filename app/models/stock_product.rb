class StockProduct < ApplicationRecord
  belongs_to :company
  belongs_to :product

  has_many :stock_product_sub_categories, dependent: :destroy
  has_many :sub_categories, through: :stock_product_sub_categories 

  accepts_nested_attributes_for :sub_categories, allow_destroy: true, reject_if: :all_blank

  validates :video_url, allow_blank: true, length: { maximum: 50 }
  validates :video_comment, :video_license, :spec, :spec_comment, :staff_comment, :price_info, :faq, :description, :address_info, :company_memo, :private_memo, :meta_description, :meta_keywords, allow_blank: true, length: { maximum: 2000 }
end
