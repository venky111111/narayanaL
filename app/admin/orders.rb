ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :shop_id, :total_services, :grand_total, 
                :pickup_time, :pickup_date, :type, :amount,  
                :razorpay_order_id, :razorpay_payment_id, 
                :razorpay_signature, :currency, :status, :track_id, 
                :address_id, :delivery_date, :payment_status,
                :pickup, :servicing, :shipping_order, :order_delivered
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :shop_id, :total_services, :grand_total, :pickup_time, :pickup_date, :type, :amount, :razorpay_order_id, :razorpay_payment_id, :razorpay_signature, :currency, :status, :track_id, :address_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


  index do
    selectable_column
    id_column
    column :user_id
    column :shop_id
    column :status
    column :type
    
    column :delivery_date do |order|
     
      order.delivery_date.present? ? order.delivery_date.strftime("%d/%m/%Y") : "Not set"
    end
    column :payment_status
    column :pickup
    column :servicing
    column :shipping_order
    column :order_delivered
   



    # end
    actions
  end


   form do |f|
    f.inputs do
      f.input :status
      f.input :delivery_date, as: :datepicker
      f.input :payment_status
      f.input :pickup, as: :datepicker
      f.input :servicing, as: :datepicker
      f.input :shipping_order, as: :datepicker
      f.input :order_delivered, as: :datepicker
     
    end
    f.actions
  end
  
end
