class PostsController < ApplicationController
  def show
    debugger
    @post = Post.find(params[:id])
  end
end
