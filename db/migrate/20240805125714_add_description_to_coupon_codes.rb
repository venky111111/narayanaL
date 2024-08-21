class AddDescriptionToCouponCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :coupon_codes, :description, :text
  end
end
