class Company < ApplicationRecord
  has_many :managers, dependent: :nullify
  has_many :staffs, dependent: :nullify
end

