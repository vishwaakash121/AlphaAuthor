class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :require_user, only: %i[edit update destroy]

  def new
    @post_id = params[:post_id]
    @comment = Comment.new
  end

  def show; end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = params[:post_id]

    if @comment.save
      redirect_to post_path(@comment.post)
    else
      flash[:notice] = 'Something Went Wrong.'
      render 'new'
    end
  end

  def edit
    if (can? :edit, @comment)
      flash[:error] = 'You are not allowed to edit others comment'
    end
  end

  def update
    if (can? :update, @comment)
      if @comment.update(comment_params)
        flash[:notice] = 'Comment was updated successfully.'
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
    if (can? :delete, @comment)
      @comment.destroy
      redirect_to post_path(@post)
    else
      flash[:error] = 'You are not allowed to delete others post'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def set_comment
    @comment = Comment.find(params[:id])
    @post = Post.find(@comment.post_id)
  end
end
