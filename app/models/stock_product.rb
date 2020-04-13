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
  validates :video_comment, :video_license, :spec, :spec_comment, :staff_comment, :price_info, :faq, :description, :address_info, :company_memo, :private_memo, :meta_description, :meta_keywords, allow_blank: true, length: { maximum: 3000 }

  scope :owns, -> { where(stock_product: nil) }
  scope :others, -> { where.not(stock_product: nil) }

  scope :product_name_or_title, -> (code_or_title) {
    conds = code_or_title.split(/\s+/).map { |c| "%#{sanitize_sql_like(c)}%" }
    code_cond = conds.map{ |c| sanitize_sql_for_conditions(["products.product_name LIKE ?", c]) }.join(' OR ')
    title_cond = conds.map{ |c| sanitize_sql_for_conditions(["products.title LIKE ?", c]) }.join(' OR ')
    where("(#{code_cond}) OR (#{title_cond})")
  }

  before_create :prepare_chartered_props_on_create
  before_update :prepare_chartered_props_on_update
  before_save :prepare_prop_types

  attr_accessor :product_code, :category_name

  def charter_from(source, attrs={})
    self.product = source.product
    self.stock_product = source

    if attrs.blank?
      source.stock_product_text_props.each do |text_prop|
        if text_prop.charterable?
          tp = TextProp.new(name: text_prop.stored_prop.name, text_content: text_prop.stored_prop.text_content, source: text_prop.stored_prop)
          self.text_props << tp
          self.stock_product_text_props.last.attributes = { charterable: true, published: text_prop.published? }
        end
      end
      source.stock_product_image_props.each do |image_prop|
        if image_prop.charterable?
          ip = ImageProp.new(name: image_prop.stored_prop.name, source: image_prop.stored_prop)
          ip.image.attach(image_prop.stored_prop.image.blob)
          self.image_props << ip
          self.stock_product_image_props.last.attributes = { charterable: true, published: image_prop.published? }
        end
      end
      source.stock_product_file_props.each do |file_prop|
        if file_prop.charterable?
          fp = FileProp.new(name: file_prop.stored_prop.name, source: file_prop.stored_prop)
          fp.file.attach(file_prop.stored_prop.file.blob)
          self.file_props << fp
          self.stock_product_file_props.last.attributes = { charterable: true, published: file_prop.published? }
        end
      end
    end

    attrs.update({video_url: source.video_url, video_comment: source.video_comment, video_license: source.video_license, video_license_valid: source.video_license_valid, video_published: source.video_published, video_charterable: source.video_charterable}) if source.video_charterable?
    attrs.update({staff_comment: source.staff_comment, staff_comment_published: source.staff_comment_published, staff_comment_charterable: source.staff_comment_charterable}) if source.staff_comment_charterable?
    attrs.update({price_info: source.price_info, price_info_published: source.price_info_published, price_info_charterable: source.price_info_charterable}) if source.price_info_charterable?
    attrs.update({faq: source.faq, faq_published: source.faq_published, faq_charterable: source.faq_charterable}) if source.faq_charterable?
    attrs.update({description: source.description, description_published: source.description_published, description_charterable: source.description_charterable}) if source.description_charterable?
    attrs.update({address_info: source.address_info, address_info_published: source.address_info_published, address_info_charterable: source.address_info_charterable}) if source.address_info_charterable?

    self.attributes = attrs
  end

  def reset_charterable_attrs
    self.text_props = text_props.reject(&:charterable?)
    self.file_props = file_props.reject(&:charterable?)
    self.image_props = image_props.reject(&:charterable?)
  end

  def as_json(options = {})
    super(options.merge(
      include: [
        :product,
        {
          company: { only: [:id, :name] },
          stock_product: { only: [:id, :company_id] },
          category: { only: [:id, :name] },
          sub_categories: { only: [:id, :name] },
          text_props: { only: [:id, :name, :text_content] },
          file_props: { methods: [:url], only: [:id, :name, :file_url] },
          image_props: { methods: [:url], only: [:id, :name, :image_url] },
        }
      ]
    ))
  end

  private
  
  def prepare_chartered_props_on_create
    return unless stock_product_id
    stock_product_text_props.each do |stock_product_text_prop|
      stock_product_text_prop.stored_prop_type = 'TextProp'
      text_prop = stock_product_text_prop.stored_prop
      if text_prop.source_id.present?
        stock_product_text_prop.charterable = true
        source_prop = TextProp.find(text_prop.source_id)
        text_prop.name = source_prop.name
        text_prop.text_content = source_prop.text_content
      end
    end
    stock_product_file_props.each do |stock_product_file_prop|
      stock_product_file_prop.stored_prop_type = 'FileProp'
      file_prop = stock_product_file_prop.stored_prop
      if file_prop.source_id.present?
        stock_product_file_prop.charterable = true
        source_prop = FileProp.find(file_prop.source_id)
        file_prop.name = source_prop.name
        file_prop.file.attach(source_prop.file.blob)
      end
    end
    stock_product_image_props.each do |stock_product_image_prop|
      stock_product_image_prop.stored_prop_type = 'ImageProp'
      image_prop = stock_product_image_prop.stored_prop
      if image_prop.source_id.present?
        stock_product_image_prop.charterable = true
        source_prop = ImageProp.find(image_prop.source_id)
        image_prop.name = source_prop.name
        image_prop.image.attach(source_prop.image.blob)
      end
    end
  end

  def prepare_chartered_props_on_update
    return unless stock_product_id
    stock_product_text_props.each do |stock_product_text_prop|
      stock_product_text_prop.stored_prop_type = 'TextProp'
      text_prop = stock_product_text_prop.stored_prop
      if text_prop.source_id.present?
        stock_product_text_prop.charterable = true
      end
    end
    stock_product_file_props.each do |stock_product_file_prop|
      stock_product_file_prop.stored_prop_type = 'FileProp'
      file_prop = stock_product_file_prop.stored_prop
      if file_prop.source_id.present?
        stock_product_file_prop.charterable = true
      end
    end
    stock_product_image_props.each do |stock_product_image_prop|
      stock_product_image_prop.stored_prop_type = 'ImageProp'
      image_prop = stock_product_image_prop.stored_prop
      if image_prop.source_id.present?
        stock_product_image_prop.charterable = true
      end
    end
  end

  def prepare_prop_types
    return if stock_product_id.present?
    stock_product_text_props.each do |stock_product_text_prop|
      stock_product_text_prop.stored_prop_type = 'TextProp'
    end
    stock_product_file_props.each do |stock_product_file_prop|
      stock_product_file_prop.stored_prop_type = 'FileProp'
    end
    stock_product_image_props.each do |stock_product_image_prop|
      stock_product_image_prop.stored_prop_type = 'ImageProp'
    end
  end

  class << self
    def form_attribute_names
      super + [
        {stock_product_sub_categories_attributes: [:id, :sub_category_id, :_destroy]},
        {stock_product_text_props_attributes: [:id, :stored_prop_id, :stored_prop_type, :published, :charterable, :_destroy,
          {stored_prop_attributes: [:id, :source_id, :name, :text_content, :_destroy]}
        ]},
        {stock_product_file_props_attributes: [:id, :stored_prop_id, :stored_prop_type, :published, :charterable, :_destroy,
          {stored_prop_attributes: [:id, :source_id, :name, :file, :_destroy]}
        ]},
        {stock_product_image_props_attributes: [:id, :stored_prop_id, :stored_prop_type, :published, :charterable, :_destroy,
          {stored_prop_attributes: [:id, :source_id, :name, :image, :_destroy]}
        ]},
        {text_props_attributes: [:id, :source_id, :name, :text_content, :_destroy]},
        {file_props_attributes: [:id, :source_id, :name, :file, :_destroy]},
        {image_props_attributes: [:id, :source_id, :name, :image, :_destroy]},
      ]
    end
  end
end
