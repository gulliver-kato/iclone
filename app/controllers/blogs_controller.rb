class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :ensure_corret_user, only: [:edit, :update]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.all
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @favorite = current_user.favorites.find_by(blog_id: @blog.id)
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  def confirm
    @blog = Blog.new(blog_params)
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = current_user.blogs.build(blog_params)

    respond_to do |format|
      if @blog.save
        BlogMailer.blog_mail(@blog).deliver
        # format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.html { redirect_to blog_path(@blog.id), notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    @blog = current_user.blogs.build(blog_params)
    render :new if @blog.invalid?
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    def ensure_corret_user
      if current_user.id != @blog.user.id
        flash[:notice] = "権限がありません"
        redirect_to blogs_path
      end
    end
    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:content, :image, :image_cache)
    end
end
