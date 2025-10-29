class AddUserAndItemToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :user, foreign_key: true unless column_exists?(:orders, :user_id)
    add_reference :orders, :item, foreign_key: true unless column_exists?(:orders, :item_id)
  end
end
