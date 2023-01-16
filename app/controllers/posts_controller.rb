class PostsController < ApplicationController
  before_action :get_post, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.paginate(page: params[:page], per_page: 5)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    if !logged_in?
      redirect_to login_path
    end

    @post = Post.new(post_params)
    @post.user = User.find(current_user.id)

    if @post.save
      flash[:notice] = "Post #{@post.title} was created successfully!"
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post was updated successfully!"
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy

    redirect_to posts_path
  end

  private

  def get_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description)
  end

  def require_same_user 
    if current_user != @post.user && !current_user.admin?
      flash[:alert] = "Sneaky little rattle snake! You can only edit or delete your own posts"

      redirect_to @post
    end
  end
end
