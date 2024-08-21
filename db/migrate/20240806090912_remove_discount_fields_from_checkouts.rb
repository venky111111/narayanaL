class RemoveDiscountFieldsFromCheckouts < ActiveRecord::Migration[6.1]
  def change
    remove_column :checkouts, :discount_from_coupon, :integer
    remove_column :checkouts, :after_coupon_final_price, :integer
    remove_column :checkouts, :grand_total, :integer
  end
end



