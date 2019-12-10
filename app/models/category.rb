class Category < ApplicationRecord
  include CompanyTraceable

  belongs_to :category, optional: true
  belongs_to :company, optional: true

  has_many :categories, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }
end

