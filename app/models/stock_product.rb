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
  has_many :stored_props, through: :stock_product_stored_props

  accepts_nested_attributes_for :stock_product_sub_categories, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stock_product_text_props, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stock_product_file_props, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stock_product_image_props, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :text_props, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :file_props, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :image_props, allow_destroy: true, reject_if: :all_blank

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

  def charter_from(source)
    self.product = source.product
    self.stock_product = source

    attrs = {}
    attrr.update({video_url: source.video_url, video_comment: source.video_comment, video_license_valid: source.video_license_valid, video_published: source.video_published, video_charterable: source.video_charterable}) if source.video_charterable?
    attrs.update({staff_comment: source.staff_comment, staff_comment_published: source.staff_comment_published, staff_comment_charterable: source.staff_comment_charterable}) if source.staff_comment_charterable?
    attrs.update({price_info: source.price_info, price_info_published: source.price_info_published, price_info_charterable: source.price_info_charterable}) if source.price_info_charterable?
    attrs.update({faq: source.faq, faq_published: source.faq_published, faq_charterable: source.faq_charterable}) if source.faq_charterable?
    attrs.update({description: source.description, description_published: source.description_published, description_charterable: source.description_charterable}) if source.description_charterable?
    attrs.update({address_info: source.address_info, address_info_published: source.address_info_published, address_info_charterable: source.address_info_charterable}) if source.address_info_charterable?
    self.attributes = attrs

    source.stock_product_text_props.each do |text_prop|
      if text_prop.charterable?
        tp = TextProp.new(name: text_prop.stored_prop.name, text_content: text_prop.stored_prop.text_content)
        self.text_props << tp
        self.stock_product_text_props.last.attributes = { charterable: true, published: text_prop.published? }
      end
    end
    source.stock_product_image_props.each do |image_prop|
      if image_prop.charterable?
        ip = ImageProp.new(name: image_prop.stored_prop.name)
        ip.image.attach(image_prop.stored_prop.image.blob)
        self.image_props << ip
        self.stock_product_image_props.last.attributes = { charterable: true, published: image_prop.published? }
      end
    end
    source.stock_product_file_props.each do |file_prop|
      if file_prop.charterable?
        fp = FileProp.new(name: file_prop.stored_prop.name)
        fp.file.attach(file_prop.stored_prop.file.blob)
        self.file_props << fp
        self.stock_product_file_props.last.attributes = { charterable: true, published: file_prop.published? }
      end
    end
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
    def form_attribute_names
      super + [
        {stock_product_sub_categories_attributes: [:id, :sub_category_id, :_destroy]},
        {stock_product_text_props_attributes: [:id, :stored_prop_id, :published, :charterable, :_destroy]},
        {stock_product_file_props_attributes: [:id, :stored_prop_id, :published, :charterable, :_destroy]},
        {stock_product_image_props_attributes: [:id, :stored_prop_id, :published, :charterable, :_destroy]},
        {text_props_attributes: [:id, :name, :text_content, :_destroy]},
        {file_props_attributes: [:id, :name, :file, :_destroy]},
        {image_props_attributes: [:id, :name, :image, :_destroy]},
      ]
    end
  end
end
