class Order < ApplicationRecord
  belongs_to :user
  belongs_to :item
  has_one :address, dependent: :destroy

  # 同じ商品は一度しか購入できない
  validates :item_id, uniqueness: true
end
