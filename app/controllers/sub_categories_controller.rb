class SubCategoriesController < ApplicationController
  before_action :require_login

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @sub_category = SubCategory.new(search_params[:sub_category])
  end

  def show
  end

  def new
    @sub_category = SubCategory.new
  end

  def edit
  end

  def create
    @sub_category = SubCategory.new(form_params)

    respond_to do |format|
      if @sub_category.save
        format.html { redirect_to sub_categories_url, notice: "#{SubCategory.model_name.human}##{@sub_category.id} を作成しました" }
        format.json { render :show, status: :created, location: @sub_category }
      else
        format.html { render :new }
        format.json { render json: @sub_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sub_category.update(form_params)
        format.html { redirect_to sub_categories_url, notice: "#{SubCategory.model_name.human}##{@sub_category.id} を更新しました" }
        format.json { render :show, status: :ok, location: @sub_category }
      else
        format.html { render :edit }
        format.json { render json: @sub_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sub_category.destroy
    respond_to do |format|
      format.html { redirect_to sub_categories_url, notice: "#{SubCategory.model_name.human}##{@sub_category.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def form_params
    params.require(:sub_category).permit(SubCategory.form_attribute_names)
  end

  def search_params
    params.permit(sub_category: SubCategory.search_attribute_names)
  end

  def fetch_resources
    @sub_categories = SubCategory.search(search_params[:sub_category]).pagination_by_params(params)
  end

  def fetch_resource
    @sub_category = SubCategory.find(params[:id])
  end
end
