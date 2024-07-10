# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    @products = Product.all

    if params[:search].present?
      @products = @products.where('products.name LIKE ? OR products.description LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    end

    if params[:category].present?
      @products = @products.joins(:category).where(categories: { id: params[:category] })
    end

    @products = @products.page(params[:page]).per(10)
  end

  def show
    @product = Product.find_by(id: params[:id])
  end
end
