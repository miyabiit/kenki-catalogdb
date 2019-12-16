class Product < ApplicationRecord
  validates :product_code, :title, presence: true
  validates :product_code, :title, allow_blank: true, length: { maximum: 50 }
  validates :qualification_comment, :description_a, :description_b, allow_blank: true, length: { maximum: 500 }
end

