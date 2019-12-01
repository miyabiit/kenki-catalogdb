class User < ApplicationRecord
  authenticates_with_sorcery!

  def display_name
    self.name.presence || self.login_name
  end


  class << self
    def form_attribute_names
      super - [:crypted_password, :salt] + [:password]
    end

    def search__attribute_names
      [:login_name, :name, :staff_role]
    end
  end
end
