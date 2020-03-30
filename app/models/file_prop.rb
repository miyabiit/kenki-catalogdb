class FileProp < StoredProp
  has_one_attached :file

  belongs_to :source, optional: true, class_name: 'FileProp'

  validates :file, presence: true, if: -> { source_id.blank? }

  validate :validate_file

  def has_changes_to_save?
    super || attachment_changes.any?
  end

  def url
    if source_id.present? && file.blank?
      return Rails.application.routes.url_helpers.rails_blob_path(source.file, only_path: true)
    end
    return '' if file.blank?
    Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end

  def file_name
    if source_id.present? && file.blank?
      return source.file.attachment.blob.filename.to_s
    end
    return '' if file.blank?
    file.attachment.blob.filename.to_s
  end

  def as_json(options = {})
    super(options.merge(methods: [:url, :file_name], only: [:id, :name]))
  end

  class << self
    def form_attribute_names
      super + [:file]
    end
  end

  private

  def validate_file
    return unless file.attached?
    if file.blob.byte_size > 100.megabytes
      # NOTE: FrozenError (can't modify frozen Hash) が発生
      #image.purge
      errors.add(:file, I18n.t('errors.messages.file_too_large'))
    end
  end
end
