class CartsController < ApplicationController
  def show
    @cart_items = session[:cart] || {}
    @products = Product.find(@cart_items.keys)
  end

  def add_item
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    session[:cart] ||= {}
    session[:cart][product_id] = (session[:cart][product_id] || 0) + quantity

    redirect_to cart_path
  end

  def update_item
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    session[:cart][product_id] = quantity
    session[:cart].delete(product_id) if quantity <= 0

    redirect_to cart_path
  end

  def remove_item
    product_id = params[:product_id].to_i
    session[:cart].delete(product_id)

    redirect_to cart_path
  end
end
