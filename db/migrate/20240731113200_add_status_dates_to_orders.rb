class AddStatusDatesToOrders < ActiveRecord::Migration[6.1]
  def change

    add_column :orders, :pickup, :date
    add_column :orders, :servicing, :date
    add_column :orders, :shipping_order, :date
    add_column :orders, :order_delivered, :date
  end
end
