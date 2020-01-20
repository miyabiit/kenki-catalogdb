class FileProp < StoredProp
  has_one_attached :file

  def url
    Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end

  def as_json(options = {})
    super(options.merge(methods: [:url], only: [:id, :name]))
  end

  class << self
    def form_attribute_names
      super + [:file]
    end
  end
end
