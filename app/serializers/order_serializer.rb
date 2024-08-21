class OrderSerializer < ActiveModel::Serializer
 
 attributes :id, :shop_id, :service_id, :items, :price, :created_at, :updated_at

  
  def items
    object.items_quantities.map do |item|
      {
        item_id: item['item_id'],
        quantity: item['quantity']
      }
    end
  end

end
