class Staff < User
  extend Enumerize

  belongs_to :company
  
  enumerize :staff_role, in: %W(read write)

  def as_json(options = {})
    super(options.merge(include: {company: {only: [:id, :name]}}))
  end
end
