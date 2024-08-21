class CouponAssignToShop < ApplicationRecord
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :coupon_codes
  validate :unique_coupon_code_for_shop

  private

  def unique_coupon_code_for_shop
    shops.each do |shop|
      coupon_codes.each do |coupon_code|
        if CouponAssignToShop.joins(:shops, :coupon_codes)
                             .where(shops: { id: shop.id }, coupon_codes: { id: coupon_code.id })
                             .exists?
          errors.add(:base, "The combination of shop #{shop.id} and coupon code #{coupon_code.id} already exists.")
        end
      end
    end
  end

end
