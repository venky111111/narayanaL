class Order < ApplicationRecord
	self.inheritance_column = :type
	belongs_to :user
	
end
