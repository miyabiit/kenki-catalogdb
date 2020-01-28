class TextProp < StoredProp
  validates :text_content, presence: true, length: { maximum: 500 }

  def url
    text_content
  end

  def file_name
    ''
  end
end
