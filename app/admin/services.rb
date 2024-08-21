ActiveAdmin.register Service do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :service_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:service_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


   index do
    selectable_column
    id_column
    column :service_name
   
    actions
  end


   form do |f|
    f.inputs do
      f.input :service_name
      
    end
    f.actions
  end
  
end
