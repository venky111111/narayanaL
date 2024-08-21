class AddOrderCancelReasonToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :order_cancel_reason, :string
    add_column :orders, :delivery_date, :date
    add_column :orders, :payment_status, :string
  end
end
