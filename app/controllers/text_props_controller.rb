class TextPropsController < ApplicationController
  before_action :require_login
  authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @text_prop = TextProp.new(search_params[:text_prop])
  end

  def show
  end

  def new
    @text_prop = TextProp.new
  end

  def edit
  end

  def create
    @text_prop = TextProp.new(form_params)

    respond_to do |format|
      if @text_prop.save
        format.html { redirect_to text_props_url, notice: "#{TextProp.model_name.human}##{@text_prop.id} を作成しました" }
        format.json { render :show, status: :created, location: @text_prop }
      else
        format.html { render :new }
        format.json { render json: @text_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @text_prop.update(form_params)
        format.html { redirect_to text_props_url, notice: "#{TextProp.model_name.human}##{@text_prop.id} を更新しました" }
        format.json { render :show, status: :ok, location: @text_prop }
      else
        format.html { render :edit }
        format.json { render json: @text_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @text_prop.destroy
    respond_to do |format|
      format.html { redirect_to text_props_url, notice: "#{TextProp.model_name.human}##{@text_prop.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def form_params
    params.require(:text_prop).permit(TextProp.form_attribute_names)
  end

  def search_params
    params.permit(text_prop: TextProp.search_attribute_names)
  end

  def fetch_resources
    @text_props = TextProp.accessible_by(current_ability).search(search_params[:text_prop]).pagination_by_params(params)
  end

  def fetch_resource
    @text_prop = TextProp.accessible_by(current_ability).find(params[:id])
  end
end
