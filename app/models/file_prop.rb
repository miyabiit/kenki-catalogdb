class FileProp < StoredProp
  has_one_attached :file

  class << self
    def form_attribute_names
      super + [:file]
    end
  end
end
