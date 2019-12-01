class StaffsController < ApplicationController
  before_action :require_login

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
  end

  def show
  end

  def new
    @staff = Staff.new
  end

  def edit
  end

  def create
    @staff = Staff.new(form_params)

    respond_to do |format|
      if @staff.save
        format.html { redirect_to staffs_url, notice: "#{Staff.model_name.human}##{@staff.id} を作成しました" }
        format.json { render :show, status: :created, location: @staff }
      else
        format.html { render :new }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @staff.update(form_params)
        format.html { redirect_to staffs_url, notice: "#{Staff.model_name.human}##{@staff.id} を更新しました" }
        format.json { render :show, status: :ok, location: @staff }
      else
        format.html { render :edit }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @staff.destroy
    respond_to do |format|
      format.html { redirect_to staffs_url, notice: "#{Staff.model_name.human}##{@staff.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private

  def form_params
    params.require(:staff).permit(Staff.form_attribute_names)
  end

  def search_params
    params.permit(Staff.search_attribute_names)
  end

  def fetch_resources
    @staffs = Staff.search(search_params).pagination_by_params(params)
  end

  def fetch_resource
    @staff = Staff.find(params[:id])
  end
end
