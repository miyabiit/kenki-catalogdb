module CompanyTraceable
  extend ActiveSupport::Concern

  included do
    before_save :prepare_company_id
    def prepare_company_id
      if Current.user && Current.user.is_a?(Staff)
        self.company = Current.user.company
      end
    end
  end
end
