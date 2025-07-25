# app/controllers/orders_controller.rb
def index
  @orders = Order.joins(:basket)
                 .where(baskets: { session_id: session.id.to_s })
                 .order(created_at: :desc)
end