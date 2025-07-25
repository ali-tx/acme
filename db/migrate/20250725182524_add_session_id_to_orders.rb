# db/migrate/[timestamp]_add_session_id_to_orders.rb
class AddSessionIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :session_id, :string
    add_index :orders, :session_id
  end
end