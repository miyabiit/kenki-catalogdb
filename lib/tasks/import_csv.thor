require 'csv'

# ex:
#   rails r lib/tasks/import_csv.thor categories hoge 3
class ImportCsv < Thor
  desc 'categories [file_name] [company_id] ', 'import categories'
  def categories(file_name, company_id = nil)
    @company_id = company_id&.to_i
    csv = CSV.read(file_name, headers: true)
    rows = csv.map {|row| row }
    # add root categories
    @category_tag_to_id = {}
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

  desc 'stock_products_with_dependencies [category_csv_file_name] [product_csv_file_name] [stock_product_csv_file_name] [company_id] ', 'import stock_products'
  def stock_products_with_dependencies(category_csv_file_name, product_csv_file_name, stock_product_csv_file_name, company_id)
    ActiveRecord::Base.transaction do
      @company_id = company_id&.to_i
      csv = CSV.read(category_csv_file_name, headers: true)
      rows = csv.map {|row| row }
      # add root categories
      @category_tag_to_id = {}
      rows.each do |row|
        if row['parent_tag'].blank?
          create_category(rows, nil, row)
        end
      end

      product_csv = CSV.read(product_csv_file_name, headers: true)
      stock_product_csv = CSV.read(stock_product_csv_file_name, headers: true)
      product_csv.each do |product_row|
        attrs = product_row.to_h  
        attrs.delete 'product_tag'
        attrs.delete 'product_code'
        attrs['product_code'] = product_row['product_tag']
        attrs['product_name'] = product_row['product_code']
        product = Product.new(attrs)
        puts product.inspect
        product.save!
        stock_product_csv.each do |stock_product_row|
          if stock_product_row['product_tag'] == product_row['product_tag']
            stock_product_attrs = stock_product_row.to_h  
            stock_product_attrs.delete 'product_tag'
            stock_product_attrs.delete 'category_tag'
            stock_product = StockProduct.new(stock_product_attrs.merge(product_id: product.id, company_id: @company_id, category_id: @category_tag_to_id[stock_product_row['category_tag']]))
            puts stock_product.inspect
            stock_product.save!
          end
        end
      end
    end
  end

  private
  def create_category(rows, parent_id, row)
    category = Category.new(category_id: parent_id, company_id: @company_id || row['company_id'], name: row['name'], position: row['position'], last: row['last'][0] == 'T')
    puts "create category = #{category.inspect}"
    category.save!
    @category_tag_to_id[row['category_tag']] = category.id
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
