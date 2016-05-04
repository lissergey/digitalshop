class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  def index
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params

    if verify_recaptcha(model: @listing) && @post.save
      redirect_to @post, notice: "Новость добавлена!"
    else
      render 'new', notice: " Что то пошло не так, не удалось создать новость!"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update post_params
      redirect_to @post, notice: "Новость успешно обновлена!"
    end
  end

  def destroy
    @post.destroy
    redirect_to post_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
  def find_post
    @post = Post.find(params[:id])
  end
end
