# app/models/basket.rb
class Basket < ApplicationRecord
  has_many :basket_items, dependent: :destroy
  has_many :products, through: :basket_items

  def self.current(session)
    find_or_create_by(session_id: session.id.to_s, completed: false)
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end