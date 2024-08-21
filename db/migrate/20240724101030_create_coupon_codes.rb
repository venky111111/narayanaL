class CreateCouponCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :coupon_codes do |t|

      t.string :code_name
      t.integer :coupon_discount
      t.datetime :starting_at
      t.datetime :expires_at
      t.integer :max_discount
      t.integer :min_order_value
      t.string :customer_type

      t.timestamps
    end
  end
end
