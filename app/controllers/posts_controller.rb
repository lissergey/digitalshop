class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_filter :check_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @post = Post.all.order("created_at desc").paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params

    if @post.save
      redirect_to @post, notice: "Новина додана!"
    else
      render 'new', notice: " Не вдалося створити новину!"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update post_params
      redirect_to @post, notice: "Новина успішно додана!"
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
  def find_post
    @post = Post.find(params[:id])
  end
  def check_user
    if !current_user.admin
      redirect_to root_url, alert: "Доступ заборонено"
    end
  end
end
