class CreateCouponAssignToShops < ActiveRecord::Migration[6.1]
  def change
    create_table :coupon_assign_to_shops do |t|
       t.integer :shop_ids, array: true, default: []
      t.integer :coupon_code_id
      t.timestamps
    end
  end
end
