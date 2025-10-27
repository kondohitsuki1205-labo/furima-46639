class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_one :order

  validates :name, :description, :image, presence: true
  validates :price, presence: true,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 300,
                    less_than_or_equal_to: 9_999_999
                  }
  
  def sold_out? = order.present?
end
