class StockProductImport < ImportBase
  def initialize(company_id)
    @company_id = company_id
  end

  def process_csv(csv)
    failed_instances = []
    @products = Product.where(product_code: csv.map {|r| r['product_code'] }).to_a
    csv.each do |stock_product_row|
      stock_product_attrs = stock_product_row.to_h  
      stock_product = StockProduct.new(stock_product_attrs)
      product = @products.find {|p| p.product_code == stock_product_row['product_code'] }
      unless product
        stock_product.errors.add :product_code, :invalid
        failed_instances << stock_product
        next
      end
      stock_product.company_id = @company_id
      stock_product.product = product
      if stock_product_row['category_name'].present?
        category = Category.where(company_id: @company_id).find_by_name(stock_product_row['category_name'])
        unless category
          stock_product.errors.add :category_name, :invalid
          failed_instances << stock_product
          next
        end
      end
      stock_product.category = category
      unless stock_product.save
        failed_instances << stock_product
      end
    end
    failed_instances
  end
end
