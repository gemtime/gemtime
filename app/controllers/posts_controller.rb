class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :previewer, only: [:show]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.order("published_at DESC").all
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)
    @post.published_at = Time.zone.now if publishing?

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    @post.published_at = Time.zone.now if publishing?
    @post.published_at = nil if unpublishing?

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def publishing?
      params[:commit] == "Publish"
    end

    def unpublishing?
      params[:commit] == "Unpublish"
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to posts_path, notice: "Not authorized to edit this post" if @post.nil?
    end

    def previewer
      if @post.published_at.blank?
        if user_signed_in?
          @post = current_user.posts.find_by(id: params[:id])
          redirect_to posts_path, notice: "Not authorized to view this post" if @post.nil?
        else
          redirect_to posts_path, notice: "Not authorized to view this post"
        end
      else
      end
    end

    def post_params
      params.require(:post).permit(:name, :body, :published_at, :user_id)
    end
end
