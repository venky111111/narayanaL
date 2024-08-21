ActiveAdmin.register Item do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :item_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:item_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
   index do
    selectable_column
    id_column
    column :item_name
   
    actions
  end


   form do |f|
    f.inputs do
      f.input :item_name
      
    end
    f.actions
  end



end
