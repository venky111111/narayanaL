ActiveAdmin.register Shop do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :shop_name, :city
  #
  # or
  #
  # permit_params do
  #   permitted = [:shop_name, :city]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


   index do
    selectable_column
    id_column
    column :shop_name
    column :city
   
    actions
  end


   form do |f|
    f.inputs do
      f.input :shop_name
      f.input :city
   
    end
    f.actions
  end
  
end
