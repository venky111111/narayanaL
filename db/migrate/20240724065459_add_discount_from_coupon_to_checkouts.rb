class AddDiscountFromCouponToCheckouts < ActiveRecord::Migration[6.1]
  def change
    add_column :checkouts, :discount_from_coupon, :integer
    add_column :checkouts, :after_coupon_final_price, :integer
  end
end
