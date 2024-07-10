class OrderTax < ApplicationRecord
  belongs_to :order

  validates :gst, :pst, :hst, :qst, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :order_id, presence: true
end
