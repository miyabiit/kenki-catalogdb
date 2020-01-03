class Category < ApplicationRecord
  include CompanyTraceable

  belongs_to :category, optional: true
  belongs_to :company, optional: true

  has_many :categories, -> { order(position: :asc) }, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }

  validate :validate_same_company

  scope :lasts, -> { where(last: true) }

  def as_json(options = {})
    super(options.merge(include: {company: {only: [:id, :name]}}))
  end

  private

  def validate_same_company
    if category && category.company && category.company_id != company_id
      errors.add :base, '会社が異なる分類を親にすることはできません'
    end
  end
end

