module StockProductsHelper
  def input_unless_charted(form, attr_name, options={})
    base_name = options.delete(:base_name) || attr_name
    unless form.object.stock_product
      return form.input attr_name, options
    end
    if attr_name.to_s =~ /charterable$/
      return form.input attr_name, options.merge(readonly: true, disabled: true)
    end
    if attr_name.to_s =~ /published$/
      return form.input attr_name, options
    end

    charterable = form.object.send("#{base_name}_charterable")

    if charterable
      return form.input attr_name, options.merge(readonly: true, disabled: true)
    end

    form.input attr_name, options
  end
end
