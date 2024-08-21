ActiveAdmin.register ServicesAssign do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :shop_id, :item_id, :service_id, :price
  #
  # or
  #
  # permit_params do
  #   permitted = [:shop_id, :item_id, :service_id, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  



 
    index do
    selectable_column
    id_column
    column :shop do |services_assign|
    
      services_assign.shop&.shop_name
    end
    column :shop do |services_assign|
    
      services_assign.shop&.city
    end
    column :item do |services_assign|
      services_assign.item&.item_name
    end
    column :service do |services_assign|
      services_assign.service&.service_name
    end
    column :price
    actions
  end


   form do |f|
    f.inputs do
 
      f.input :shop, as: :select, collection: Shop.all.pluck(:shop_name, :id)
      f.input :item, as: :select, collection: Item.all.pluck(:item_name, :id)
      f.input :service, as: :select, collection: Service.all.pluck(:service_name, :id)
      f.input :price
      
    end
    f.actions
  end

end
