class PostsController < ApplicationController
  
  before_action :set_post, only: %i[show edit update destroy]
  before_action :require_user, except: %i[show index]

  def show
  end

  def index
    @posts = Post.paginate(page: params[:page], per_page: 2)
  end

  def edit 
    if !(can? :edit, @post)
      flash[:error] = 'You are not allowed to edit others post'
      redirect_back(fallback_location: root_path)
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = 'Post was created successfully.'
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def update
    if (can? :update, @post)
      if @post.update(post_params)
        flash[:notice] = 'Post was updated successfully.'
        redirect_to @post
      else
        render 'edit'
      end
    else
      flash[:error] = 'You are not allowed to update others post'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if (can? :delete, @post)
      @post.destroy
      redirect_to posts_path
    else
      flash[:error] = 'You are not allowed to delete others post'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :publish_date, :author, :tags)
  end
end
