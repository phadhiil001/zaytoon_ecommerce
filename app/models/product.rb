class Product < ApplicationRecord
  belongs_to :category

  has_many_attached :images

  serialize :options, Array, coder: JSON
  serialize :extra, Hash, coder: JSON
end
