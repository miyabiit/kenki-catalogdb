class StockProduct < ApplicationRecord
  include CompanyTraceable

  belongs_to :company, optional: true
  belongs_to :product
  belongs_to :category, optional: true
  belongs_to :stock_product, optional: true

  has_many :stock_product_sub_categories, dependent: :destroy
  has_many :sub_categories, through: :stock_product_sub_categories 

  has_many :stock_product_stored_props, dependent: :destroy
  has_many :stock_product_text_props, -> { where(stored_prop_type: 'TextProp') }, class_name: 'StockProductStoredProp'
  has_many :stock_product_file_props, -> { where(stored_prop_type: 'FileProp') }, class_name: 'StockProductStoredProp'
  has_many :stock_product_image_props, -> { where(stored_prop_type: 'ImageProp') }, class_name: 'StockProductStoredProp'

  accepts_nested_attributes_for :stock_product_sub_categories, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stock_product_text_props, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stock_product_file_props, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stock_product_image_props, allow_destroy: true, reject_if: :all_blank

  validates :video_url, allow_blank: true, length: { maximum: 50 }
  validates :video_comment, :video_license, :spec, :spec_comment, :staff_comment, :price_info, :faq, :description, :address_info, :company_memo, :private_memo, :meta_description, :meta_keywords, allow_blank: true, length: { maximum: 2000 }

  scope :owns, -> { where(stock_product: nil) }
  scope :others, -> { where.not(stock_product: nil) }

  scope :product_code_or_title, -> (code_or_title) {
    conds = code_or_title.split(/\s+/).map { |c| "%#{sanitize_sql_like(c)}%" }
    code_cond = conds.map{ |c| sanitize_sql_for_conditions(["products.product_code LIKE ?", c]) }.join(' OR ')
    title_cond = conds.map{ |c| sanitize_sql_for_conditions(["products.title LIKE ?", c]) }.join(' OR ')
    where("(#{code_cond}) OR (#{title_cond})")
  }

  class << self
    def form_attribute_names
      super + [
        {stock_product_sub_categories_attributes: [:id, :sub_category_id, :_destroy]},
        {stock_product_text_props_attributes: [:id, :stored_prop_id, :published, :charterable, :_destroy]},
        {stock_product_file_props_attributes: [:id, :stored_prop_id, :published, :charterable, :_destroy]},
        {stock_product_image_props_attributes: [:id, :stored_prop_id, :published, :charterable, :_destroy]},
      ]
    end
  end
end
