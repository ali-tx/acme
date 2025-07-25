module BasketsHelper
  def calculate_subtotal(basket)
    basket.basket_items.sum { |item| item.product.price * item.quantity }
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
end