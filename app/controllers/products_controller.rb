class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update, :destroy]

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    @product.user = current_user
    if @product.save
      ProductMailer.notify_product_owner(@product).deliver_now
      redirect_to @product
      # same as redirect_to product_path(@product)
    else
      # render will simply render the new.html.erb view in the views/products
      # directory. The #new action above will not be touched.
      render :new
    end
  end

  def index
    if params[:tag]
      @tag = Tag.find_or_initialize_by(name: params[:tag])
      @products = @tag.products.order(created_at: :DESC)
    else
      @products = Product.order(created_at: :DESC)
    end
  end

  def show
    @review = Review.new
    # In this case only the product owner will have all reviews available in the
    # through @reviews (including hidden reviews).
    # You could also remove this logic here and do some logic in the view. Your use case (and
    # for now, the size of your Rails toolset) will determine the best way to things.
    # We've done it this way because with the tools available to us it minimizes the
    # amount of repeated code and if else statements in our view.
    if can? :crud, @product
      @reviews = @product.reviews.sort_by { |review| -1 * review.vote_total }
      # We're only using sort_by here because the records are limited to the number of reviews for
      # a specifc product. If we were having to sort thousands of records on every product page
      # this wouldn't be very performant as 'sort_by' will load the entire collection into
      # memory. Here is an ugly SQL statement that works instead:
      # @reviews = @product.reviews.left_outer_joins(:votes).select("reviews.*", "SUM(CASE WHEN votes.is_up = TRUE then 1 ELSE 0 END + CASE WHEN votes.is_up = FALSE then -1 ELSE 0 END) AS votes_count").group("reviews.id").order("votes_count DESC")
      # If we wanted to use a SQL statement we should probably refactor into a method in our Review model,
      # but we may also want to also refactor how we're storing up/down votes in the db.
    else
      @reviews = @product.reviews.where(hidden: false).sort_by { |review| -1 * review.vote_total }
    end
    @favourite = @product.favourites.find_by_user_id current_user if user_signed_in?
  end

  def edit
  end

  def update
    if @product.update product_params
      redirect_to product_path(@product)
    else
      render :edit
    end
  end

  def destroy
   @product.destroy
   redirect_to products_path
  end

  private

  def product_params
    # strong parameters are used primarily as a security practice to help
    # prevent accidentally allowing users to update sensitive model attributes.
    params.require(:product).permit(:title, :description, :price, :tag_names)
  end

  def find_product
    @product = Product.find params[:id]
  end

  def authorize!
    redirect_to root_path, alert: "access denied" unless can? :crud, @product
  end
end
