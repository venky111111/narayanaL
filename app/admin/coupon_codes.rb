ActiveAdmin.register CouponCode do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :code_name, :coupon_discount, :starting_at, :expires_at, :max_discount, :min_order_value, :customer_type, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:code, :coupon_discount, :starting_at, :expires_at, :max_discount, :min_order_value, :customer_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  

    index do
    selectable_column
    id_column
    column :code_name
    column :coupon_discount
    column :max_discount
    column :min_order_value
    column :starting_at
    column :expires_at
    column :customer_type
    column :description
    actions
  end

     form do |f|
    f.inputs do
      f.input :code_name
      f.input :coupon_discount
      f.input :max_discount
      f.input :min_order_value
      f.input :starting_at, as: :datepicker
      f.input :expires_at, as: :datepicker
      f.input :customer_type, as: :select, collection: ['Every user', 'New user']
      f.input :description
      
    end
    f.actions
  end


end
