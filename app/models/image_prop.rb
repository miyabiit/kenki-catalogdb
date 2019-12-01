class ImageProp < StoredProp
  has_one_attached :image

  class << self
    def form_attribute_names
      super + [:image]
    end
  end
end
