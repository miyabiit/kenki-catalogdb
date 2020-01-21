class CharteredStockProductsController < ApplicationController
  before_action :require_login
  authorize_resource :stock_product, parent: false

  before_action :fetch_source
  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @stock_product = StockProduct.new(search_params[:stock_product])
  end

  def show
    render 'stock_products/show'
  end

  def new
    @stock_product = StockProduct.new
    @stock_product.charter_from(@source)
  end

  def edit
    @product = @stock_product.product
  end

  def create
    @stock_product = StockProduct.new(form_params)
    unless @source
      @stock_product.errors.add :base, 'チャーター元が未設定です'
    end
    @stock_product.stock_product = @source
    @stock_product.product = @source.product

    respond_to do |format|
      if @stock_product.save
        format.html { redirect_to chartered_stock_products_url, notice: "チャーター商品##{@stock_product.id} を作成しました" }
        format.json { render 'stock_products/show', status: :created, location: @stock_product }
      else
        format.html { render 'chartered_stock_products/new' }
        format.json { render json: @stock_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock_product.update(form_params)
        format.html { redirect_to chartered_stock_products_url, notice: "チャーター商品##{@stock_product.id} を更新しました" }
        format.json { render 'stock_products/show', status: :ok, location: @stock_product }
      else
        format.html { render 'chartered_stock_products/edit' }
        format.json { render json: @stock_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stock_product.destroy
    respond_to do |format|
      format.html { redirect_to chartered_stock_products_url, notice: "チャーター商品##{@stock_product.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def form_params
    params.require(:stock_product).permit(StockProduct.form_attribute_names)
  end

  def search_params
    params.permit(stock_product: StockProduct.search_attribute_names)
  end

  def fetch_resources
    @stock_products = StockProduct.joins(:product).includes(:product).accessible_by(current_ability).where.not(stock_product_id: nil)
    if params[:product_code_or_title].present?
      @stock_products = @stock_products.product_code_or_title(params[:product_code_or_title])
    end
    @stock_products = @stock_products.search(search_params[:stock_product]).pagination_by_params(params)
  end

  def fetch_resource
    @stock_product = StockProduct.includes(:product).accessible_by(current_ability).where.not(stock_product_id: nil).find(params[:id])
  end

  def fetch_source
    @source = StockProduct.find(params[:stock_product_id]) if params[:stock_product_id].present?
  end
end
