class StoredProp < ApplicationRecord
  include CompanyTraceable

  belongs_to :source, optional: true, class_name: 'StoredProp'
  belongs_to :company, optional: true

  has_many :stock_product_stored_props, dependent: :destroy, inverse_of: :stored_prop
  has_many :stored_prop_sub_categories, dependent: :destroy
  has_many :sub_categories, through: :stored_prop_sub_categories

  validates :name, presence: true, length: { maximum: 50 }

  def as_json(options = {})
    super(options.merge(include: {company: {only: [:id, :name]}}))
  end
end

