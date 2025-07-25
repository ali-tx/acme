class Product < ApplicationRecord
  has_many :basket_items
  has_many :baskets, through: :basket_items
end