class ProductsController < ApplicationController
  before_action :require_login

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(form_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_url, notice: "#{Product.model_name.human}##{@product.id} を作成しました" }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(form_params)
        format.html { redirect_to products_url, notice: "#{Product.model_name.human}##{@product.id} を更新しました" }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "#{Product.model_name.human}##{@product.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def form_params
    params.require(:product).permit(Product.form_attribute_names)
  end

  def search_params
    params.permit(Product.search_attribute_names)
  end

  def fetch_resources
    @products = Product.search(search_params).pagination_by_params(params)
  end

  def fetch_resource
    @product = Product.find(params[:id])
  end
end
