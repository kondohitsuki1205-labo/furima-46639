class AddSelectIdsToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :category_id, :integer
    add_column :items, :status_id, :integer
    add_column :items, :shipping_fee_id, :integer
    add_column :items, :prefecture_id, :integer
    add_column :items, :scheduled_delivery_id, :integer
  end
end
