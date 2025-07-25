# app/controllers/concerns/basket_initializer.rb
module BasketInitializer
  extend ActiveSupport::Concern

  included do
    before_action :initialize_basket
    helper_method :current_basket
  end

  def initialize_basket
    @basket ||= Basket.current(session)
    session[:basket_id] = @basket.id
  end

  def current_basket
    @basket
  end
end