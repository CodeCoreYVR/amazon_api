class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favourites = current_user.favourited_products.order("favourites.created_at DESC")
  end

  def create
    product = Product.find params[:product_id]
    favourite = Favourite.new user: current_user, product: product
    if !can?(:favourite, product)
      redirect_to product, alert: "can't favourite product"
    elsif favourite.save
      redirect_to product, notice: 'Favourited'
    else
      redirect_to product, alert: 'Not Favourited'
    end
  end

  def destroy
    favourite = Favourite.find params[:id]
    if can? :destroy, favourite
      favourite.destroy
      redirect_to favourite.product, notice: 'favourite removed'
    else
      redirect_to favourite.product, alert: "can't delete favourite"
    end
  end
end
