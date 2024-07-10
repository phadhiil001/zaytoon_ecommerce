class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true, uniqueness: true
  # validates :description, length: { maximum: 500 }, allow_blank: true
end
