class PostsController < ApplicationController
  def index
    @articles = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
  end

  def create
    @post = Post.new(params.require(:post).permit(:title, :description))
    
    @post.save

    redirect_to @post
  end
end
