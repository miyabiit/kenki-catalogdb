class StockProductsController < ApplicationController
  before_action :require_login
  authorize_resource

  before_action :fetch_parent
  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @stock_product = StockProduct.new(search_params[:stock_product])
  end

  def show
  end

  def new
    @stock_product = StockProduct.new
  end

  def edit
    @product = @stock_product.product
  end

  def create
    @stock_product = StockProduct.new(form_params)
    @stock_product.product = @product if @product

    respond_to do |format|
      if @stock_product.save
        format.html { redirect_to stock_products_url, notice: "#{StockProduct.model_name.human}##{@stock_product.id} を作成しました" }
        format.json { render :show, status: :created, location: @stock_product }
      else
        format.html { render :new }
        format.json { render json: @stock_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock_product.update(form_params)
        format.html { redirect_to stock_products_url, notice: "#{StockProduct.model_name.human}##{@stock_product.id} を更新しました" }
        format.json { render :show, status: :ok, location: @stock_product }
      else
        format.html { render :edit }
        format.json { render json: @stock_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stock_product.destroy
    respond_to do |format|
      format.html { redirect_to stock_products_url, notice: "#{StockProduct.model_name.human}##{@stock_product.id} を削除しました" }
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
    @stock_products = StockProduct.joins(:product).includes(:product).accessible_by(current_ability).where(company_id: current_user.company_id).where(stock_product_id: nil)
    if params[:product_name_or_title].present?
      @stock_products = @stock_products.product_name_or_title(params[:product_name_or_title])
    end
    @stock_products = @stock_products.search(search_params[:stock_product]).pagination_by_params(params)
  end

  def fetch_resource
    @stock_product = StockProduct.includes(:product).accessible_by(current_ability).where(stock_product_id: nil).find(params[:id])
  end

  def fetch_parent
    @product = Product.accessible_by(current_ability).find(params[:product_id]) if params[:product_id].present?
  end
end
