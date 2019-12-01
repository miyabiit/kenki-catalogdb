class Staff < User
  extend Enumerize

  belongs_to :company
  
  enumerize :staff_role, in: %W(read write)
end
