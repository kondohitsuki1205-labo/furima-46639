class OrderAddress
  include ActiveModel::Model

  attr_accessor :token, :postal_code, :prefecture_id, :city, :block, :building,
                :phone_number, :user_id, :item_id

  with_options presence: true do
    validates :token
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/ }
    validates :prefecture_id, numericality: { other_than: 1 }
    validates :city
    validates :block
    validates :phone_number, format: { with: /\A\d{10,11}\z/ }
    validates :user_id
    validates :item_id
  end

  def save
    order = Order.create!(user_id:, item_id:)
    Address.create!(
      order_id: order.id,
      postal_code:,
      prefecture_id:,
      city:,
      block:,
      building:,
      phone_number:
    )
  end
end