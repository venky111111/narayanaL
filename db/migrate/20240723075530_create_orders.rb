class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :shop_id
      t.jsonb :total_services, null: false, default: '{}'
      t.integer :grand_total
      t.time :pickup_time
      t.date :pickup_date
      t.string  :type
      t.integer :amount
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.string :razorpay_signature  
      t.string :currency

      t.timestamps
    end
    add_index :orders, [:shop_id]
  end
end
