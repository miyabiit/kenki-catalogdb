class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :pagination_by_params, -> (params) { 
    res = all
    if params['sort'].present?
      params['sort'].each do |k, v|
        res = res.order(k.underscore => v)
      end
    end
    res = res.page(params['page'].presence || 1) 
    if params['limit'].present?
      res = res.per(params['limit'])
    end
    res
  }

  class << self
    def attribute_names_without_timestamps
      attribute_names.map(&:to_sym) - [:created_at, :updated_at]
    end

    def form_attribute_names
      attribute_names_without_timestamps
    end

    def search_attribute_names
      attribute_names_without_timestamps
    end

    def search(params)
      q = all
      params = params.select do |key, value|
        if value.is_a? Hash
          if value.present?
            ref_klass = key.singularize.camelize.constantize
            ref_q = ref_klass.search(value).where("#{ref_klass.table_name}.#{self.table_name.singularize}_id = #{self.table_name}.id")
            q = q.where("EXISTS(#{ref_q.to_sql})")
          end
          false
        elsif attribute_names.include?(key)
          if self.column_for_attribute(key).type == :string && value.present?
            if value.present?
              q = q.where(["#{self.table_name}.#{key} LIKE ?", "%#{value}%"])
            end
            false
          else
            value.present?
          end
        elsif key =~ /_on\z/ && attribute_names.include?(key.gsub(/_on\z/, '_at'))
          if value.present?
            real_key = key.gsub(/_on\z/, '_at')
            target_time = Time.parse(value)
            q = q.where(real_key => (target_time.beginning_of_day .. target_time.end_of_day))
          end
          false
        end
      end
      q = q.where(params)
      q
    end
  end
end
