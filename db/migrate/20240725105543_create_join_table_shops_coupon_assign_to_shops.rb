class CreateJoinTableShopsCouponAssignToShops < ActiveRecord::Migration[6.1]
  def change
    create_join_table :shops, :coupon_assign_to_shops do |t|
      t.index :shop_id
      t.index :coupon_assign_to_shop_id
    end
  end
end
