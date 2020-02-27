require 'csv'

# ex:
#   rails r lib/tasks/import_csv.thor categories hoge 3
class ImportCsv < Thor
  desc 'categories [file_name] [company_id] ', 'import categories'
  def categories(file_name, company_id = nil)
    @company_id = company_id&.to_i
    csv = CSV.read(file_name, headers: true)
    rows = csv.map {|row| row }
    trees = {}
    # add root categories
    rows.each do |row|
      if row['parent_tag'].blank?
        create_category(rows, nil, row)
      end
    end
  end

  desc 'products [file_name] [company_id] ', 'import products'
  def products(file_name, company_id = nil)
    csv = CSV.read(file_name, headers: true)
    csv.each do |row|
      puts row.inspect
    end
  end

  desc 'stock_products [file_name] [company_id] ', 'import stock_products'
  def stock_products(file_name, company_id = nil)
    csv = CSV.read(file_name, headers: true)
    csv.each do |row|
      puts row.inspect
    end
  end

  private
  def create_category(rows, parent_id, row)
    category = Category.new(category_id: parent_id, company_id: @company_id || row['company_id'], name: row['name'], position: row['position'], last: row['last'][0] == 'T')
    #puts "create category = #{category.inspect}"
    category.save
    rows.each do |child_row|
      if child_row['parent_tag'] == row['category_tag']
        create_category(rows, category.id, child_row)
        #create_category(rows, row['category_tag'], child_row)
      end
    end
  end
end

if $0 === __FILE__
  ImportCsv.start(ARGV)
end
