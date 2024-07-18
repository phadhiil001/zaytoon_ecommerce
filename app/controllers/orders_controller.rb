class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :add_item, :update_item, :remove_item, :invoice, :checkout, :destroy]

  def show
    @order_items = @order.order_items
  end

  def past_orders
    @orders = current_user.orders.where.not(status: 'new')
  end

  def add_item
    @product = Product.find(params[:product_id])
    @order_item = @order.order_items.find_or_initialize_by(product: @product)

    if @order_item.new_record?
      @order_item.quantity = params[:quantity].to_i
    else
      @order_item.quantity += params[:quantity].to_i
    end

    @order_item.price = @product.price
    @order_item.save!

    redirect_to order_path(@order), notice: "Product added to order"
  end

  def update_item
      @order_item = @order.order_items.find(params[:item_id])
      if @order_item.update(quantity: params[:order_item][:quantity])
        redirect_to order_path(@order), notice: "Order item updated"
      else
        redirect_to order_path(@order), alert: "Unable to update order item"
      end
    end

    def remove_item
      @order_item = @order.order_items.find(params[:item_id])
      @order_item.destroy
      redirect_to order_path(@order), notice: "Order item removed"
    end

  # def invoice
  #   if current_user.address.blank? || current_user.province.blank?
  #     flash[:alert] = "Please provide your address and province."
  #     redirect_to edit_user_registration_path
  #     return
  #   end

  #   @order_items = @order.order_items
  #   @order_tax = @order.order_tax || calculate_taxes(@order)
  # end
  #
  def invoice
    @order_items = @order.order_items
    @order_tax = calculate_taxes(@order)

    if current_user.address.blank? || current_user.province.blank?
      flash[:alert] = "Please provide your address and province."
      redirect_to edit_user_registration_path
    end
  end

# def checkout
#   @order_items = @order.order_items
#   @order_tax = @order.order_tax || calculate_taxes(@order)

#   if @order.update(status: 'paid', total_price: @order.total_price + @order_tax.total_tax)
#     redirect_to success_order_path(@order), notice: "Order completed successfully"
#   else
#     render :invoice
#   end
# end


# def checkout
#   @order_items = @order.order_items
#   @order_tax = @order.order_tax || calculate_taxes(@order)

#   session = Stripe::Checkout::Session.create(
#     payment_method_types: ['card'],
#     line_items: [{
#       name: 'Order from Zaytoon',
#       amount: (@order.total_price * 100).to_i,
#       currency: 'cad',
#       quantity: 1
#     }],
#     customer_email: current_user.email,
#     metadata: {
#       order_id: @order.id,
#       user_id: current_user.id
#     },
#     success_url: success_order_url(@order),
#     cancel_url: cancel_order_url(@order)
#   )

#   redirect_to session.url, allow_other_host: true
# end

def create_checkout_session
  @order = Order.find(params[:id])
  @order_items = @order.order_items
  @order_tax = calculate_taxes(@order)

  session = Stripe::Checkout::Session.create(
    payment_method_types: ['card'],
    mode: 'payment',
    line_items: @order_items.map do |item|
      {
        price_data: {
          currency: 'cad',
          product_data: {
            name: item.product.name
          },
          unit_amount: (item.price * 100).to_i
        },
        quantity: item.quantity
      }
    end,
    success_url: success_order_url(@order),
    cancel_url: order_url(@order),
    metadata: { order_id: @order.id }
  )

  redirect_to session.url, allow_other_host: true
end


def checkout
  @order_items = @order.order_items
  @order_tax = @order.order_tax || calculate_taxes(@order)

  token = params[:stripeToken]

  begin
    charge = Stripe::Charge.create(
      amount: (@order.total_price * 100).to_i,
      currency: 'cad',
      description: 'Order Payment',
      source: token,
      metadata: { order_id: @order.id }
    )

    if charge.paid
      @order.update(status: 'paid', total_price: @order.total_price + @order_tax.total_tax)
      redirect_to success_order_path(@order), notice: "Order completed successfully"
    else
      flash[:alert] = "Payment failed. Please try again."
      render :invoice
    end
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    render :invoice
  end
end

  # def confirm
  #   @order_items = @order.order_items
  #   @order_tax = calculate_taxes(@order)
  # end

  def destroy
    @order.destroy
    redirect_to past_orders_orders_path, notice: "Order deleted successfully"
  end

  # def success
  #   @order = Order.find(params[:id])
  # end

  def success
    @order = Order.find(params[:id])
    @order.update(status: 'paid')
    @order_items = @order.order_items
    @order_tax = @order.order_tax
  end

  def cancel
    # Handle the case when the user cancels the payment
  end

  private

  def set_order
    @order = current_user.orders.find_or_create_by(status: 'new')
    @order.total_price = calculate_total_price(@order)
    @order.save
  end

  def calculate_total_price(order)
    order.order_items.sum { |item| item.price * item.quantity }
  end

  def calculate_taxes(order)
    province = current_user.province
    gst = province.gst || 0
    pst = province.pst || 0
    hst = province.hst || 0
    qst = province.qst || 0

    order_tax = order.order_tax || order.build_order_tax
    order_tax.update(gst: gst, pst: pst, hst: hst, qst: qst)
    order_tax
  end

  def order_params
  params.require(:order).permit(:status, :total_price)
end

end
