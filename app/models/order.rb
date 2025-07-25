# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :basket
  enum status: { pending: 'pending', completed: 'completed', failed: 'failed' }

  validates :total, presence: true

  def self.for_session(session_id)
    where(session_id: session_id).order(created_at: :desc)
  end
end