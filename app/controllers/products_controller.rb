class ProductsController < ApplicationController
  before_action :require_login
  authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @product = Product.new(search_params[:product])
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

  def import
  end

  def upload
    @failed_instances = ProductImport.new.import(params['csv_file'].path)
    if @failed_instances.present?
      render action: :import
    else
      flash[:notice] = '商品をインポートしました'
      redirect_to action: :index
    end
  rescue ActiveModel::UnknownAttributeError, Encoding::InvalidByteSequenceError, CSV::MalformedCSVError
    flash.now[:alert] = '不正なCSVファイルです'
    render action: :import
  end

  private

  def form_params
    params.require(:product).permit(Product.form_attribute_names)
  end

  def search_params
    params.permit(product: Product.search_attribute_names)
  end

  def fetch_resources
    @products = Product.accessible_by(current_ability).search(search_params[:product]).pagination_by_params(params)
  end

  def fetch_resource
    @product = Product.accessible_by(current_ability).find(params[:id])
  end
end
