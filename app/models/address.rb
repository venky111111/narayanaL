class Address < ApplicationRecord

	validates :house_number, :street, :landmark, :direction_to_reach, presence: true
	belongs_to :user

end
