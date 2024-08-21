class AddCouponConfettiToCheckouts < ActiveRecord::Migration[6.1]
  def change
    add_column :checkouts, :coupon_confetti, :boolean, default: false
  end
end
