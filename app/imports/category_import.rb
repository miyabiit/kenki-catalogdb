class CategoryImport < ImportBase
  def initialize(company_id)
    @company_id = company_id
    @failed_instances = []
  end

  def process_csv(csv)
    create_csv, update_csv = partition_create_or_update(csv)
    @new_categories = build_new_categories(create_csv)
    @persisted_categories = build_persisted_categories(update_csv)
    @persisted_categories.each do |c|
      if c.parent_category_name.presence != c.category&.name
        if c.parent_category_name.present? && c.parent_category_name != c.name
          c.category = fetch_category_by_name(c.parent_category_name)
          unless c.category
            c.errors.add :parent_category_name, 'は存在しません'
          end
        end
      end
      if c.errors.empty? && c.save
      else
        @failed_instances << c
      end
    end
    @new_categories.each do |c|
      next if @failed_instances.any? {|f| f.name == c.name }
      next if c.id
      if c.parent_category_name.present? && c.parent_category_name != c.name
        c.category = fetch_category_by_name(c.parent_category_name)
        unless c.category
          c.errors.add :parent_category_name, 'は存在しません'
        end
      end
      if c.errors.empty? && c.save
      else
        @failed_instances << c
      end
    end
    @failed_instances
  end

  private

  def partition_create_or_update(rows)
    names = rows.map {|row| row['name']&.strip }.compact
    @categories = Category.where(company_id: @company_id, name: names).to_a
    saved_names = @categories.map(&:name)
    rows.partition {|row| !saved_names.include?(row['name']) }
  end

  def build_new_categories(rows)
    rows.map do |row|
      Category.new(company_id: @company_id, name: row['name'], position: row['position'], last: row['last'][0] == 'T', parent_category_name: row['parent_category_name'])
    end
  end

  def build_persisted_categories(rows)
    rows.map do |row|
      category = @categories.find {|c| c.name == row['name']}
      category.attributes = {
        company_id: @company_id, position: row['position'], last: row['last'][0] == 'T', parent_category_name: row['parent_category_name']
      }
      category
    end
  end

  def fetch_category_by_name(name)
    category = @persisted_categories.find {|c| c.name == name }
    return category if category
    category = @new_categories.find {|c| c.name == name }
    if category
      unless category.id 
        if category.parent_category_name.present? && category.parent_category_name != category.name
          category.category = fetch_category_by_name(category.parent_category_name)
          unless category.category
            category.errors.add :parent_category_name, 'は存在しません'
          end
        end
        if category.errors.empty? && category.save
          category.reload unless category.id
        else
          @failed_instances << category
        end
      end
      return category
    end
    Category.where(company_id: @company_id).find_by_name(name)
  end
end
