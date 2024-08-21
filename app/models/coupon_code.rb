class CouponCode < ApplicationRecord
  has_and_belongs_to_many :coupon_assign_to_shops
   has_many :shops, through: :coupon_assign_to_shops  #added for chektwo
end



