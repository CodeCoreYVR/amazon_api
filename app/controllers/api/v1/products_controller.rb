class Api::V1::ProductsController < Api::ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize!, only: [:update, :destroy]

  def index
    products = Product.order(created_at: :desc)
    render json: products, each_serializer: ProductCollectionSerializer
  end

  def show
    render json: product
  end

  def create
    product = Product.new product_params
    product.user = current_user
    if product.save
      render json: { id: product.id }
    else
      render(
        json: { errors: product.errors },
        status: 422 # Unprocessable Entity
      )
    end
  end

  def update
    if product.update product_params
      render json: { id: product.id }
    else
      render(
        json: { errors: product.errors },
        status: 422 # Unprocessable Entity
      )
    end
  end

  def destroy
    product.destroy
    render(json: { status: 200 }, status: 200)
  end


  private

  def product_params
    params.require(:product).permit(:title, :description, :price, tag_ids: [])
  end

  def product
    @product ||= Product.find params[:id]
  end

  def authorize!
    render(json: { status: 401 }, status: 401) unless can? :crud, product
  end

end