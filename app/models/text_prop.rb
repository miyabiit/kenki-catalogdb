class TextProp < StoredProp
  validates :text_content, presence: true, length: { maximum: 500 }
end
