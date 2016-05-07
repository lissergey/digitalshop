class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
#  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_filter :check_user, only: [:new, :create, :edit, :update, :destroy]

  def search
    if params[:search].present?
      @listings = Listing.search(params[:search])
    else
      @listings = Listing.all
    end
  end

  def index
    @listings = Listing.all.order("created_at desc").paginate(:page => params[:page], :per_page => 9)
    if params[:category].present?
      @category_id = Category.find_by(name: params[:category]).id
      @listings = Listing.where(category_id: @category_id).order("created_at DESC").paginate(:page => params[:page], :per_page => 9)
    end
    if params[:producer].present?
      @producer_id = Producer.find_by(name: params[:producer]).id
      @listings = Listing.where(producer_id: @producer_id).order("created_at DESC").paginate(:page => params[:page], :per_page => 9)
    end
    if params[:producer].present? && params[:category].present?
      @category_id = Category.find_by(name: params[:category]).id
      @producer_id = Producer.find_by(name: params[:producer]).id
      @listings = Listing.where(producer_id: @producer_id, category_id: @category_id).order("created_at DESC").paginate(:page => params[:page], :per_page => 9)
    end
    @listings = @listings.where("price >= ?", params["min_price"]) if params["min_price"].present?
    @listings = @listings.where("price <= ?", params["max_price"]) if params["max_price"].present?
  end

  def show
    @reviews = Review.where(listing_id: @listing.id).order("created_at DESC")
  end

  def new
    @listing = Listing.new
  end

  def edit
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Товар успішно додано.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Товар успішно оновлено.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Товар успішно видалено.' }
      format.json { head :no_content }
    end
  end

  private

    def set_listing
      @listing = Listing.find(params[:id])
    end

    def listing_params
      params.require(:listing).permit(:name, :category_id, :producer_id, :description, :price, :specification, :image)
    end

    def check_user
      if !current_user.admin
        redirect_to root_url, alert: "Доступ заборонено"
      end
    end
end
