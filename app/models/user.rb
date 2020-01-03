class User < ApplicationRecord
  authenticates_with_sorcery!

  MAX_TOKEN_COUNT = Rails.env.production? ? 1 : 10

  has_many :access_tokens, dependent: :destroy

  def generate_token
    token = SecureRandom.base64(32)
    transaction do
      token_count = access_tokens.count
      if token_count >= MAX_TOKEN_COUNT
        access_tokens.order(:created_at).limit((token_count + 1) - MAX_TOKEN_COUNT).delete_all
      end
      access_tokens.create!(token: token)
    end
    token
  end

  def display_name
    self.name.presence || self.login_name
  end

  def role_name
    case self
    when Administrator
      :admin
    else
      self.staff_role == 'write' ? :manager : :staff
    end
  end

  def as_json(options = {})
    super(options.merge(except: [:remember_me_token_expires_at, :remember_me_token, :crypted_password, :salt]))
  end

  class << self
    def form_attribute_names
      super - [:crypted_password, :salt] + [:password]
    end

    def search__attribute_names
      [:login_name, :name, :staff_role]
    end

    def find_by_access_token(token)
      AccessToken.find_by(token: token)&.user
    end
  end
end
