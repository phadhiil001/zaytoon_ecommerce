class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many_attached :images

  serialize :options, Array, coder: JSON
  serialize :extra, Hash, coder: JSON

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category_id, presence: true
end
