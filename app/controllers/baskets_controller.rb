# app/controllers/baskets_controller.rb
class BasketsController < ApplicationController
  before_action :initialize_basket

  def show
    @products = Product.all
  end

  def add_item
    product = Product.find(params[:product_id])
    basket_item = @basket.basket_items.find_or_initialize_by(product_id: product.id)
    basket_item.quantity ||= 0
    basket_item.quantity += 1
    basket_item.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("basket-count",
                               partial: "baskets/count",
                               locals: { basket: @basket.reload }
          ),
          turbo_stream.append("flash-messages",
                              partial: "shared/flash",
                              locals: { message: "#{product.name} added to basket", type: "success" }
          )
        ]
      end
      format.html { redirect_to basket_path }
    end
  end
  # app/controllers/baskets_controller.rb
  def remove_item
    basket_item = @basket.basket_items.find_by(id: params[:id])

    if basket_item
      basket_item.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("basket-item-#{params[:id]}"),
            turbo_stream.replace("basket-count",
                                 html: "<span id='basket-count'>#{@basket.reload.basket_items.sum(:quantity)}</span>")
          ]
        end
        format.html { redirect_to basket_path, notice: 'Product removed from basket' }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to basket_path }
      end
    end
  end
  def checkout
    @subtotal = calculate_subtotal(@basket)
    @discount = calculate_discount(@basket)
    @delivery = calculate_delivery(@subtotal - @discount)
    @total = @subtotal - @discount + @delivery
  end

  def orders
    @orders = Order.for_session(session.id.to_s).completed
  end

  def complete_purchase
    @subtotal = calculate_subtotal(@basket)
    @discount = calculate_discount(@basket)
    @delivery = calculate_delivery(@subtotal - @discount)
    @total = @subtotal - @discount + @delivery

    @order = Order.create!(
      basket: @basket,
      total: @total,
      status: :completed,
      session_id: session.id.to_s
    )

    # Mark basket as completed instead of destroying it
    @basket.update!(completed: true)
    session[:basket_id] = nil

    redirect_to order_confirmation_path(order_id: @order.id),
                notice: 'Thank you for your purchase!'
  rescue => e
    redirect_to basket_path, alert: "Error completing purchase: #{e.message}"
  end

  def order_confirmation
    @order = Order.find(params[:order_id])
  end

  def remove_item
    basket_item = @basket.basket_items.find_by(id: params[:id])

    if basket_item
      basket_item.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("basket-item-#{params[:id]}"),
            turbo_stream.replace("basket-count",
                                 html: "<span id='basket-count'>#{@basket.reload.basket_items.sum(:quantity)}</span>")
          ]
        end
        format.html { redirect_to basket_path, notice: 'Product removed from basket' }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to basket_path }
      end
    end
  end


  private

  def initialize_basket
    @basket = Basket.current(session)
    session[:basket_id] = @basket.id
  end
  def calculate_total(basket)
    subtotal = basket.basket_items.sum { |item| item.product.price * item.quantity }
    discount = calculate_discount(basket)
    delivery = calculate_delivery(subtotal - discount)
    subtotal - discount + delivery
  end

  def calculate_discount(basket)
    red_items = basket.basket_items.joins(:product).where(products: { code: 'R01' }).first
    return 0 unless red_items && red_items.quantity >= 2

    red_product = red_items.product
    (red_items.quantity / 2) * (red_product.price / 2)
  end

  def calculate_delivery(amount)
    if amount >= 90
      0
    elsif amount >= 50
      2.95
    else
      4.95
    end
  end

  def calculate_subtotal(basket)
    basket.basket_items.sum { |item| item.product.price * item.quantity }
  end
end