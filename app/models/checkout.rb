class Checkout < ApplicationRecord

	belongs_to :shop
	belongs_to :user
	validates_uniqueness_of :user_id, :message => "is already being used"
	

end
