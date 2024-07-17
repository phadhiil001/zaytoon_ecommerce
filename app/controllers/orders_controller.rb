class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :add_item, :update_item, :remove_item, :invoice, :checkout, :confirm]

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

  def invoice
    if current_user.address.blank? || current_user.province.blank?
      flash[:alert] = "Please provide your address and province."
      redirect_to edit_user_registration_path
      return
    end

    @order_items = @order.order_items
    @order_tax = @order.order_tax || calculate_taxes(@order)
  end

  def checkout
    @order_items = @order.order_items
    @order_tax = @order.order_tax || calculate_taxes(@order)

    if @order.update(order_params.merge(status: 'paid', total_price: @order.total_price + @order_tax.total_tax))
      redirect_to order_path(@order), notice: "Order completed successfully"
    else
      render :invoice
    end
  end

  def confirm
    @order_items = @order.order_items
    @order_tax = calculate_taxes(@order)
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
    params.permit(:address, :province_id)
  end
end
