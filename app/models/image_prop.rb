class ImageProp < StoredProp
  has_one_attached :image

  belongs_to :source, optional: true, class_name: 'ImageProp'

  validates :image, presence: true, if: -> { source_id.blank? }

  validate :validate_image

  def has_changes_to_save?
    super || attachment_changes.any?
  end

  def url
    base_path = Rails.configuration.active_storage_base_path
    if source_id.present? && image.blank?
      return base_path + Rails.application.routes.url_helpers.rails_blob_path(source.image, only_path: true)
    end
    return '' if image.blank?
    base_path + Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end

  def file_name
    if source_id.present? && image.blank?
      return source.image.attachment.blob.filename.to_s
    end
    return '' if image.blank?
    image.attachment.blob.filename.to_s
  end

  def as_json(options = {})
    super(options.merge(methods: [:url], only: [:id, :name]))
  end

  class << self
    def form_attribute_names
      super + [:image]
    end
  end

  private

  def validate_image
    return unless image.attached?
    if image.blob.byte_size > 10.megabytes
      # NOTE: FrozenError (can't modify frozen Hash) が発生
      #image.purge
      errors.add(:image, I18n.t('errors.messages.file_too_large'))
    elsif !(image.blob.content_type =~ /\Aimage\//)
      #image.purge
      errors.add(:image, I18n.t('errors.messages.file_invalid_format'))
    end
  end
end
