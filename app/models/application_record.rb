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
      attribute_names_without_timestamps + %w[$or $like $gt $lt $lte $gte $eq $ne $in].map {|op| Hash[op.to_sym, {}] }
    end

    def search(params)
      params ||= {}
      parse_search_param(all, params, nil)
    end

    def parse_search_param(q, params, context_key)
      context_table_name = self.table_name
      params = params.select do |key, value|
        if key[0] == '$'
          case key.to_s
          when '$or'
            case value
            when Array
              value.each_with_index do |v, i|
                if i == 0
                  q = parse_search_param(q, v, context_key)
                else
                  q = q.or(parse_search_param(all, v, context_key))
                end
              end
            when Hash, ActionController::Parameters
              value.to_h.each_with_index do |(k, v), i|
                if i == 0
                  q = parse_search_param(q, Hash[k, v], context_key)
                else
                  q = q.or(parse_search_param(all, Hash[k, v], context_key))
                end
              end
            end
          when '$like'
            next unless value.is_a? String
            q = q.where(["#{context_table_name}.#{context_key} LIKE ?", "%#{value}%"])
          when '$eq'
            q = q.where(["#{context_table_name}.#{context_key} = ?", value])
          when '$lt'
            q = q.where(["#{context_table_name}.#{context_key} < ?", value])
          when '$gt'
            q = q.where(["#{context_table_name}.#{context_key} > ?", value])
          when '$lte'
            q = q.where(["#{context_table_name}.#{context_key} <= ?", value])
          when '$gte'
            q = q.where(["#{context_table_name}.#{context_key} >= ?", value])
          when '$ne'
            q = q.where(["#{context_table_name}.#{context_key} != ?", value])
          when '$in'
            q = q.where(["#{context_table_name}.#{context_key} IN (?)", value])
          else
            raise ArgumentError, "未対応の検索オペレーター - #{key}"
          end
        elsif value.is_a? Hash
          if value.present?
            operator_hash, relation_attr_hash = value.partition {|k, v| k[0] == '$'}.map(&:to_h)
            unless attribute_names.include?(key)
              ref_klass = key.singularize.camelize.constantize
              ref_q = ref_klass.search(relation_attr_hash).where("#{ref_klass.table_name}.#{context_table_name.singularize}_id = #{context_table_name}.id")
              q = q.where("EXISTS(#{ref_q.to_sql})")
            end
            operator_hash.each do |k, v|
              q = parse_search_param(q, Hash[k, v], key)
            end
          end
        elsif attribute_names.include?(key)
          if self.column_for_attribute(key).type == :string && value.present?
            if value.present?
              q = q.where(["#{context_table_name}.#{key} LIKE ?", "%#{value}%"])
            end
          else
            q = q.where(Hash[key, value]) if value.present?
          end
        elsif key =~ /_on\z/ && attribute_names.include?(key.gsub(/_on\z/, '_at'))
          if value.present?
            real_key = key.gsub(/_on\z/, '_at')
            target_time = Time.parse(value)
            q = q.where(real_key => (target_time.beginning_of_day .. target_time.end_of_day))
          end
        else
          q = q.where(Hash[key, value]) if value.present?
        end
      end
      q
    end
  end
end
