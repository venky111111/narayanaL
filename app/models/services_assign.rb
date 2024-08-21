class ServicesAssign < ApplicationRecord
	self.table_name = "services_assign"
	
  belongs_to :shop
  belongs_to :item
  belongs_to :service

  
end
