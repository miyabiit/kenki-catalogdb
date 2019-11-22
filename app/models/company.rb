class Company < ApplicationRecord
  has_many :managers, dependent: :nullify
  has_many :staffs, dependent: :nullify

  validates :uid, :name, presence: true, length: { maximum: 50 }
  validates :uid, uniqueness: true
end

