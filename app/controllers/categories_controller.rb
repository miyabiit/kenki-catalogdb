class CategoriesController < ApplicationController
  before_action :require_login
  authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @category = Category.new(search_params[:category])
    if search_params.dig(:category, :last).nil?
      @category.last = nil
    end
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(form_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_url, notice: "#{Category.model_name.human}##{@category.id} を作成しました" }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(form_params)
        format.html { redirect_to categories_url, notice: "#{Category.model_name.human}##{@category.id} を更新しました" }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: "#{Category.model_name.human}##{@category.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def form_params
    params.require(:category).permit(Category.form_attribute_names)
  end

  def search_params
    params.permit(category: Category.search_attribute_names)
  end

  def fetch_resources
    @categories = Category.accessible_by(current_ability).search(search_params[:category]).pagination_by_params(params)
  end

  def fetch_resource
    @category = Category.accessible_by(current_ability).find(params[:id])
  end
end
