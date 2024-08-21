class ShopSerializer < ActiveModel::Serializer
  attributes :id, :shop_name, :city, :shop_image,  :service_name

  def shop_image
    "https://images.unsplash.com/photo-1702971916861-1db6219a2e00?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  end

  def service_name
    
    service_names = []
    object.services.each do |service|
      service_names << service.service_name
    end
    service_names.uniq
  end

end
