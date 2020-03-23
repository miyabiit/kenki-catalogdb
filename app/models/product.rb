class Product < ApplicationRecord
  validates :product_code, :title, presence: true
  validates :product_code, :title, :product_name, :product_short_name, :product_model_name, :manufacture_name, allow_blank: true, length: { maximum: 50 }
  validates :qualification_comment, :description_a, :description_b, allow_blank: true, length: { maximum: 500 }
end

