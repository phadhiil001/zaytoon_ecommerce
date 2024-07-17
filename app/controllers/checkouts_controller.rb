class CheckoutsController < ApplicationController
  def new
    @order = Order.new
    @cart_items = session[:cart] || {}
    @products = Product.find(@cart_items.keys)
  end

  def create
    @order = current_user.orders.new(order_params)
    @cart_items = session[:cart] || {}

    Order.transaction do
      if @order.save
        @cart_items.each do |product_id, quantity|
          product = Product.find(product_id)
          @order.order_items.create!(
            product: product,
            quantity: quantity,
            price: product.price
          )
        end

        # Calculate and save taxes
        province = current_user.province
        order_tax = @order.build_order_tax(
          gst: province.gst,
          pst: province.pst,
          hst: province.hst,
          qst: province.qst
        )
        order_tax.save!

        # Clear the cart
        session[:cart] = {}
        redirect_to order_path(@order), notice: 'Order successfully created.'
      else
        render :new
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:address, :province_id)
  end
end
