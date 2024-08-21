class Shop < ApplicationRecord
  has_many :services_assigns
  has_many :items, through: :services_assigns
  has_many :services, through: :services_assigns
  has_and_belongs_to_many :coupon_assign_to_shops
  has_many :coupon_codes, through: :coupon_assign_to_shops 

    
end
