class StockProductSubCategory < ApplicationRecord
  belongs_to :stock_product
  belongs_to :sub_category

  validates :sub_category_id, uniqueness: { scope: :stock_product_id }
end
