class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_filter :check_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    if current_user.admin?
      @categories = Category.all
    else
      redirect_to root_path, notice: "Доступ заборонено"
    end
  end

  def show
  end

  def new
    if current_user.admin?
      @category = Category.new
    else
      redirect_to root_path, notice: "Доступ заборонено"
    end
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Категорія створена.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Категорію оновлено.' }
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
      format.html { redirect_to categories_url, notice: 'Категорія успішно створена.' }
      format.json { head :no_content }
    end
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def check_user
      if !current_user.admin
        redirect_to root_url, alert: "У вас не достатньо превілегій для доступу"
      end
    end
end
