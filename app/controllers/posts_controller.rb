class PostsController < ApplicationController
  def index
    @articles = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    flash[:notice] = "Post updated successfully!"

    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params.require(:post).permit(:title, :description))
    
    if @post.save
      flash[:notice] = "Post #{@post.title} was created successfully!"
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(params.require(:post).permit(:title, :description))
      flash[:notice] = "Post was updated successfully!"
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end
end
