class CompaniesController < ApplicationController
  before_action :require_login

  before_action :fetch_company, only: [:show, :edit, :update, :destroy]
  before_action :fetch_companies, only: [:index]

  # GET /companies
  # GET /companies.json
  def index
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, notice: "#{Company.model_name.human}##{@company.id} を作成しました" }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to companies_url, notice: "#{Company.model_name.human}##{@company.id} を更新しました" }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: "#{Company.model_name.human}##{@company.id} を削除しました" }
      format.json { head :no_content }
    end
  end

  private
    def fetch_company
      @company = Company.find(params[:id])
    end

    def fetch_companies
      @companies = Company.all.page(params[:page])
    end

    def company_params
      params.require(:company).permit(:uid, :name)
    end
end
