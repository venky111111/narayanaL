ActiveAdmin.register Workspace do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :content, :image, :sub_title
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :content, :image]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end



   index do
    selectable_column
    id_column
    column :title
    column :content
    column :sub_title
   
    actions
  end


   form do |f|
    f.inputs do
      f.input :title
      f.input :content
      f.input :sub_title
      
    end
    f.actions
  end


  
end
