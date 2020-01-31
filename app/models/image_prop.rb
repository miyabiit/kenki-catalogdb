class ImageProp < StoredProp
  has_one_attached :image

  validates :image, presence: true, if: -> { source_id.blank? }

  def url
    return '' if image.blank?
    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end

  def file_name
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
end
