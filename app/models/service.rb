class Service < ApplicationRecord

  has_many :services_assigns
  has_many :items, through: :services_assigns


   has_many :shops, through: :services_assigns
   

end
