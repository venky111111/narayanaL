class AddDiscountAndFinalPriceToCheckouts < ActiveRecord::Migration[6.1]
  def change
    add_column :checkouts, :total_after_discount, :integer
    add_column :checkouts, :discount, :integer
    add_column :checkouts, :total, :integer
    add_column :checkouts, :coupon_code, :string
  end
end
