class ImagePropsController < ApplicationController
  before_action :require_login
  authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @image_prop = ImageProp.new(search_params[:image_prop])
  end

  def show
  end

  def new
    @image_prop = ImageProp.new
  end

  def edit
  end

  def create
    @image_prop = ImageProp.new(form_params)

    respond_to do |format|
      if @image_prop.save
        format.html { redirect_to image_props_url, notice: "#{ImageProp.model_name.human}##{@image_prop.id} を作成しました" }
        format.json { render :show, status: :created, location: @image_prop }
      else
        format.html { render :new }
        format.json { render json: @image_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @image_prop.update(form_params)
        format.html { redirect_to image_props_url, notice: "#{ImageProp.model_name.human}##{@image_prop.id} を更新しました" }
        format.json { render :show, status: :ok, location: @image_prop }
      else
        format.html { render :edit }
        format.json { render json: @image_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @image_prop.destroy
    respond_to do |format|
      format.html { redirect_to image_props_url, notice: "#{ImageProp.model_name.human}##{@image_prop.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def form_params
    params.require(:image_prop).permit(ImageProp.form_attribute_names)
  end

  def search_params
    params.permit(image_prop: ImageProp.search_attribute_names)
  end

  def fetch_resources
    @image_props = ImageProp.accessible_by(current_ability).search(search_params[:image_prop]).pagination_by_params(params)
  end

  def fetch_resource
    @image_prop = ImageProp.accessible_by(current_ability).find(params[:id])
  end
end
