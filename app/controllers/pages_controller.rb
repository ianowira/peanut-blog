class PagesController < ApplicationController
  def index
    redirect_to posts_path if logged_id?
  end

  def about
  end
end
