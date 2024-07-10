# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    @products = Product.all

    if params[:search].present?
      Rails.logger.debug "Search query: #{params[:search]}"
      @products = @products.where('name LIKE ? OR description LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    end

    if params[:category].present?
      Rails.logger.debug "Category filter: #{params[:category]}"
      @products = @products.joins(:category).where(categories: { id: params[:category] })
    end

    @products = @products.page(params[:page]).per(10)
  end

  def show
    @product = Product.find_by(id: params[:id])
  end
end
