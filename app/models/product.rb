class Product < ApplicationRecord
  include CompanyTraceable

  belongs_to :category
  belongs_to :company, optional: true

  has_many :product_sub_categories, dependent: :destroy
  has_many :sub_categories, through: :product_sub_categories

  validates :product_code, :title, presence: true
  validates :product_code, :title, allow_blank: true, length: { maximum: 50 }
  validates :video_url, allow_blank: true, length: { maximum: 256 }
  validates :qualification_comment, :description_a, :description_b, :video_comment, :video_license_memo, allow_blank: true, length: { maximum: 500 }

  accepts_nested_attributes_for :product_sub_categories, reject_if: :all_blank, allow_destroy: true

  class << self
    def form_attribute_names
      super + [{product_sub_categories_attributes: [:id, :sub_category_id, :_destroy]}]
    end
  end
end

