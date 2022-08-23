class PostsController < ApplicationController
  def index
    @articles = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end
end
