class SubCategory < ApplicationRecord
  include CompanyTraceable

  belongs_to :company, optional: true

  validates :name, presence: true, length: { maximum: 50 }
  validates :name, uniqueness: { scope: :company_id, case_sensitive: true }
end

