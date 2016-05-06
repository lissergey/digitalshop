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
    if params[:price].present?
      #@listings = Listing.all
      @listings = Listing.all.order("created_at desc").paginate(:page => params[:page], :per_page => 9)
      @listings = @listings.where(price: params["price"])
    elsif params[:category].present?
      @category_id = Category.find_by(name: params[:category]).id
      @listings = Listing.where(category_id: @category_id).order("created_at DESC")
    else
      #@listings = Listing.all.order("created_at DESC")
      @listings = Listing.all.order("created_at desc").paginate(:page => params[:page], :per_page => 9)
    end
  end

  def show
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
      params.require(:listing).permit(:name, :category_id, :description, :price, :specification, :image)
    end

    def check_user
      if !current_user.admin
        redirect_to root_url, alert: "Доступ заборонено"
      end
    end
end
