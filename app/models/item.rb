class Item < ApplicationRecord

  has_many :services_assigns
  has_many :services, through: :services_assigns


end
