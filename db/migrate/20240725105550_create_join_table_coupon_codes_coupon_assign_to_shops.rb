class CreateJoinTableCouponCodesCouponAssignToShops < ActiveRecord::Migration[6.1]
  def change
    create_join_table :coupon_codes, :coupon_assign_to_shops do |t|
      t.index :coupon_code_id
      t.index :coupon_assign_to_shop_id
    end
  end
end
