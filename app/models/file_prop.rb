class FileProp < StoredProp
  has_one_attached :file

  validates :file, presence: true, if: -> { source_id.blank? }

  def url
    return '' if file.blank?
    Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end

  def file_name
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
end
