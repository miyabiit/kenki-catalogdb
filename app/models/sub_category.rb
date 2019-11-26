class SubCategory < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :name, uniqueness: true
end

