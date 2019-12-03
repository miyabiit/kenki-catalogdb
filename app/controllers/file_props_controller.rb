class FilePropsController < ApplicationController
  before_action :require_login

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @file_prop = FileProp.new(search_params[:file_prop])
  end

  def show
  end

  def new
    @file_prop = FileProp.new
  end

  def edit
  end

  def create
    @file_prop = FileProp.new(form_params)

    respond_to do |format|
      if @file_prop.save
        format.html { redirect_to file_props_url, notice: "#{FileProp.model_name.human}##{@file_prop.id} を作成しました" }
        format.json { render :show, status: :created, location: @file_prop }
      else
        format.html { render :new }
        format.json { render json: @file_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @file_prop.update(form_params)
        format.html { redirect_to file_props_url, notice: "#{FileProp.model_name.human}##{@file_prop.id} を更新しました" }
        format.json { render :show, status: :ok, location: @file_prop }
      else
        format.html { render :edit }
        format.json { render json: @file_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @file_prop.destroy
    respond_to do |format|
      format.html { redirect_to file_props_url, notice: "#{FileProp.model_name.human}##{@file_prop.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def form_params
    params.require(:file_prop).permit(FileProp.form_attribute_names)
  end

  def search_params
    params.permit(file_prop: FileProp.search_attribute_names)
  end

  def fetch_resources
    @file_props = FileProp.search(search_params[:file_prop]).pagination_by_params(params)
  end

  def fetch_resource
    @file_prop = FileProp.find(params[:id])
  end
end
