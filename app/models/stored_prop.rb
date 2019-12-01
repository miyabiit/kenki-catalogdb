class StoredProp < ApplicationRecord
  has_many :stored_prop_sub_categories, dependent: :destroy
  has_many :sub_categories, through: :stored_prop_sub_categories

  validates :name, presence: true, length: { maximum: 50 }
end

