class ProductImport < ImportBase
  def process_csv(csv)
    failed_instances = []
    create_csv, update_csv = partition_create_or_update(csv)
    create_csv.each do |product_row|
      attrs = product_row.to_h  
      product = Product.new(attrs)
      unless product.save
        failed_instances << product
      end
    end
    update_csv.each do |product_row|
      product = Product.find_by_product_code(product_row['product_code'])
      unless product.update(product_row.to_h)
        failed_instances << product
      end
    end
    failed_instances
  end

  private
  def partition_create_or_update(rows)
    product_codes = rows.map {|row| row['product_code'].strip }
    @products = Product.where(product_code: product_codes).to_a
    saved_names = @products.map(&:product_code)
    rows.partition {|row| !saved_names.include?(row['product_code']) }
  end
end
