class Company < ApplicationRecord
  has_many :managers, dependent: :nullify
  has_many :staffs, dependent: :nullify
  has_many :sub_categories, dependent: :destroy
  has_many :stored_props, dependent: :destroy

  validates :uid, :name, presence: true, length: { maximum: 50 }
  validates :uid, uniqueness: true
end

