class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_one :order_tax

  # validates :status, presence: true, inclusion: { in: ['new', 'paid', 'shipped'] }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
end
