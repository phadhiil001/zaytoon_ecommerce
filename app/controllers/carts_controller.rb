# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :initialize_cart

  def show
    @products = Product.find(@cart.keys)
  end

  def add_item
    product_id = params[:product_id].to_s
    quantity = (params[:quantity] || 1).to_i

    if @cart[product_id]
      @cart[product_id] += quantity
    else
      @cart[product_id] = quantity
    end

    session[:cart] = @cart
    redirect_to cart_path, notice: 'Item added to cart'
  end

  def update_item
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    if quantity > 0
      @cart[product_id] = quantity
    else
      @cart.delete(product_id)
    end

    session[:cart] = @cart
    redirect_to cart_path, notice: 'Cart updated'
  end

  def remove_item
    product_id = params[:product_id].to_s
    @cart.delete(product_id)

    session[:cart] = @cart
    redirect_to cart_path, notice: 'Item removed from cart'
  end

  private

  def initialize_cart
    @cart = session[:cart] ||= {}
  end
end
