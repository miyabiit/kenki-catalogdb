class StoredPropSubCategory < ApplicationRecord
  belongs_to :stored_prop
  belongs_to :sub_category

  validates :stored_prop_id, uniqueness: { scope: :sub_category_id }
end
