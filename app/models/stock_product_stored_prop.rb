class StockProductStoredProp < ApplicationRecord
  belongs_to :stock_product
  belongs_to :stored_prop, polymorphic: true
  accepts_nested_attributes_for :stored_prop

  def as_json(options = {})
    super(options.merge(
      include: [
        stored_prop: {
          methods: [:url]
        }
      ]
    ))
  end
end
