ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params  :phone_number, :email, :password_digest,  :full_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :full_phone_number, :country_code, :phone_number, :email, :activated, :email_verified, :mobile_verified, :device_id, :unique_auth_id, :password_digest, :type, :username, :is_blacklisted, :platform, :gender, :two_factor_auth, :suspend_until, :date_of_birth, :whatsapp_communication, :full_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end



   index do
    selectable_column
    id_column
    column :full_name
    column :email
    column :phone_number
    actions
  end

  form do |f|
    f.inputs do
      f.input :full_name
      f.input :phone_number
      f.input :phone_number
    end
    f.actions
  end


  
end
