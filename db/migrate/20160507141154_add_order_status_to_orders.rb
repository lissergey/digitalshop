class AddOrderStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :orders_statuses, :string
  end
end
