class StockProduct < ApplicationRecord
  include CompanyTraceable

  belongs_to :company, optional: true
  belongs_to :product
  belongs_to :category, optional: true
  belongs_to :stock_product, optional: true

  has_many :stock_product_sub_categories, dependent: :destroy
  has_many :sub_categories, through: :stock_product_sub_categories 

  has_many :stock_product_stored_props, dependent: :destroy, inverse_of: :stock_product
  has_many :stock_product_text_props, -> { where(stored_prop_type: 'TextProp') }, class_name: 'StockProductStoredProp', inverse_of: :stock_product
  has_many :stock_product_file_props, -> { where(stored_prop_type: 'FileProp') }, class_name: 'StockProductStoredProp', inverse_of: :stock_product
  has_many :stock_product_image_props, -> { where(stored_prop_type: 'ImageProp') }, class_name: 'StockProductStoredProp', inverse_of: :stock_product
  has_many :text_props, through: :stock_product_text_props, source: 'stored_prop', source_type: 'TextProp'
  has_many :file_props, through: :stock_product_file_props, class_name: 'FileProp', source: 'stored_prop', source_type: 'FileProp'
  has_many :image_props, through: :stock_product_image_props, class_name: 'ImageProp', source: 'stored_prop', source_type: 'ImageProp'

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

  def charterable_attributes
    # TODO: chaterable = true のものだけ返すようにする
    attrs = {}

    attrr.update({video_url: video_url, video_comment: video_comment, video_license_valid: video_license_valid, video_published: video_published, video_charterable: video_charterable}) if video_charterable?
    attrs.update({staff_comment: staff_comment, staff_comment_published: staff_comment_published, staff_comment_charterable: staff_comment_charterable}) if staff_comment_charterable?
    attrs.update({price_info: price_info, price_info_published: price_info_published, price_info_charterable: price_info_charterable}) if price_info_charterable?
    attrs.update({faq: faq, faq_published: faq_published, faq_charterable: faq_charterable}) if faq_charterable?
    attrs.update({description: description, description_published: description_published, description_charterable: description_charterable}) if description_charterable?
    attrs.update({address_info: address_info, address_info_published: address_info_published, address_info_charterable: address_info_charterable}) if address_info_charterable?

    # TODO: 属性のコピー
#     t_props = []
#     stock_product_text_props.each do |prop|
#       t_props << {stored_prop: prop.stored_prop, published: prop.published, charterable: prop.charterable} if prop.charterable
#     end
#     attrs.update({stock_product_text_props_attributes: t_props})

#     i_props = []
#     stock_product_image_props.each do |prop|
#       i_props << {stored_prop: prop.stored_prop, published: prop.published, charterable: prop.charterable} if prop.charterable
#     end
#     attrs.update({stock_product_image_props_attributes: i_props})

#     f_props = []
#     stock_product_file_props.each do |prop|
#       f_props << {stored_prop: prop.stored_prop, published: prop.published, charterable: prop.charterable} if prop.charterable
#     end
#     attrs.update({stock_product_file_props_attributes: f_props})


    attrs
  end

  def as_json(options = {})
    super(options.merge(
      include: [
        :product,
        {
          company: { only: [:id, :name] },
          stock_product: { only: [:id] },
          category: { only: [:id, :name] },
          sub_categories: { only: [:id, :name] },
          text_props: { only: [:id, :name, :text_content] },
          file_props: { methods: [:url], only: [:id, :name, :file_url] },
          image_props: { methods: [:url], only: [:id, :name, :image_url] },
        }
      ]
    ))
  end

  class << self
    def charterable_attribute_names
      [
        :video_url,
        :video_comment,
        :video_license,
        :video_license_valid,
        :video_published,
        :video_charterable,
        :staff_comment,
        :staff_comment_published,
        :staff_comment_charterable,
        :price_info,
        :price_info_published,
        :price_info_charterable,
        :faq,
        :faq_published,
        :faq_charterable,
        :description,
        :description_published,
        :description_charterable,
        :address_info,
        :address_info_published,
        :address_info_charterable
      ]
    end

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
