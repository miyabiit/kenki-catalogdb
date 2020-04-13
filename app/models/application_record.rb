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

  scope :search, ->(params, search_context={}) {
    params ||= {}
    parse_search_param(all, params, nil, search_context)
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

    def searchable_attr?(attr_name)
      attribute_names.include?(attr_name.to_s) && search_attribute_names.include?(attr_name.to_sym)
    end

    # TODO:複雑なthroughへの対応
    # TODO:foreign_key 指定時の対処
    # TODO:polymorphic relationへの対処
    def parse_search_param(q, params, context_key, search_context)
      context_table_name = self.table_name
      if alias_name = alias_name_from_search_context(search_context)
        context_table_name = alias_name
        q = q.reselect("*").from("#{self.table_name} #{context_table_name}")
      end
      params = params.select do |key, value|
        key = key.to_s
        if key[0] == '$'
          case key
          when '$or'
            case value
            when Array
              value.each_with_index do |v, i|
                if i == 0
                  q = parse_search_param(q, v, context_key, search_context)
                else
                  q = q.or(parse_search_param(all, v, context_key, search_context))
                end
              end
            when Hash, ActionController::Parameters
              value.to_h.each_with_index do |(k, v), i|
                if i == 0
                  q = parse_search_param(q, Hash[k, v], context_key, search_context)
                else
                  q = q.or(parse_search_param(all, Hash[k, v], context_key, search_context))
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
            if searchable_attr?(key)
              value.select {|k, v| k[0] == '$'}.each do |k, v|
                q = parse_search_param(q, Hash[k, v], key, search_context)
              end
            else
              relation_klass = reflect_on_association(key)
              case relation_klass
              when ActiveRecord::Reflection::BelongsToReflection
                ref_klass = relation_klass.klass
                ref_klass_table_name = ref_klass.table_name
                if ref_klass == self # 自己参照クエリ
                  ref_klass_table_name = "_#{self.table_name}"
                  search_context = {alias_name: ref_klass_table_name}
                end
                ref_q = ref_klass.unscoped.search(value, search_context).where("#{context_table_name}.#{ref_klass.table_name.singularize}_id = #{ref_klass_table_name}.id")
                q = q.where("EXISTS(#{ref_q.to_sql})")
              when ActiveRecord::Reflection::HasManyReflection
                ref_klass = relation_klass.klass
                ref_q = ref_klass.unscoped.search(value).where("#{ref_klass.table_name}.#{context_table_name.singularize}_id = #{context_table_name}.id")
                q = q.where("EXISTS(#{ref_q.to_sql})")
              when ActiveRecord::Reflection::ThroughReflection
                ref_klass = relation_klass.klass
                through_relation = relation_klass.through_reflection
                if through_relation.is_a? ActiveRecord::Reflection::HasManyReflection
                  ref_q = ref_klass.unscoped.left_joins(through_relation.table_name.to_sym).search(value).where("#{through_relation.table_name}.#{context_table_name.singularize}_id = #{context_table_name}.id")
                  q = q.where("EXISTS(#{ref_q.to_sql})")
                end
              end
            end
          end
        elsif searchable_attr?(key)
          if self.column_for_attribute(key).type == :string && value.present?
            if value.present?
              q = q.where(["#{context_table_name}.#{key} LIKE ?", "%#{value}%"])
            end
          else
            q = q.where(Hash["#{context_table_name}.#{key}", value]) if value.present?
          end
        elsif key =~ /_on\z/ && searchable_attr?(key.gsub(/_on\z/, '_at'))
          if value.present?
            real_key = key.gsub(/_on\z/, '_at')
            target_time = Time.parse(value)
            q = q.where("#{context_table_name}.#{real_key}" => (target_time.beginning_of_day .. target_time.end_of_day))
          end
        end
      end
      q
    end

    def alias_name_from_search_context(search_context)
      search_context[:alias_name]
    end
  end
end
