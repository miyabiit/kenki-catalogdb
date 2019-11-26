class Category < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :company

  has_many :categories, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }
end

