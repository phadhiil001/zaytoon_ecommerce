class Province < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :gst, :pst, :hst, :qst, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end
