class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true, uniqueness: true
  # validates :description, length: { maximum: 500 }, allow_blank: true

  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "image", "name", "updated_at"]
  end

end
