class StockProductStoredProp < ApplicationRecord
  belongs_to :stock_product
  belongs_to :stored_prop, polymorphic: true
  accepts_nested_attributes_for :stored_prop

  def build_stored_prop(params)
    unless %W(TextProp FileProp ImageProp).include?(stored_prop_type)
      raise ArgumentError, "Invalid stored_prop_type = #{stored_prop_type}"
    end
    self.stored_prop = stored_prop_type.constantize.new(params)
  end

  def as_json(options = {})
    super(options.merge(
      include: [
        stored_prop: {
          methods: [:url, :file_name]
        }
      ]
    ))
  end
end
