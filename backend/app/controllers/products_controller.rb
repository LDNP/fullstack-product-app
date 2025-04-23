class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    products = Product.all

    if params[:filter] == 'available'
      products = products.where(available: true)
    elsif params[:filter] == 'unavailable'
      products = products.where(available: false)
    end

    render json: products, status: :ok
  end

  # GET /products/:id
  def show
    render json: @product, status: :ok
  end

  # POST /products
  def create
    product = Product.new(product_params)

    if product.save
      render json: product, status: :created
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/:id
  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :available)
  end
end