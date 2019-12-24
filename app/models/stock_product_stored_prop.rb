class StockProductStoredProp < ApplicationRecord
  belongs_to :stock_product
  belongs_to :stored_prop, polymorphic: true
end
