class PostsController < ApplicationController
  before_action :ensure_author, only: [:edit, :update]

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    @post.sub_id = params[:sub_id]

    if @post.save
      redirect_to sub_post_url(sub_id: @post.sub_id, id: @post.id)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to sub_post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content)
  end

  def ensure_author
    unless current_user.id == Post.find(params[:id]).author_id
      redirect_to subs_url
    end
  end

end
