class ImageProp < StoredProp
  has_one_attached :image

  def url
    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
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
