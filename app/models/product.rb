class Product < ApplicationRecord
  belongs_to :category

  has_many :product_sub_categories, dependent: :destroy
  has_many :sub_categories, through: :product_sub_categories

  validates :product_code, :title, presence: true
  validates :product_code, :title, allow_blank: true, length: { maximum: 50 }
  validates :video_url, allow_blank: true, length: { maximum: 256 }
  validates :qualification_comment, :description_a, :description_b, :video_comment, :video_license_memo, allow_blank: true, length: { maximum: 500 }
end

