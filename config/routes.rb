Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/login', to: 'authentication#login'
  resources :users
  resources :addresses
  resources :workspaces
  resources :services
  resources :shops
  resources :items
  resources :orders
  resources :services_assigns
  resources :checkouts
  resources :time_slot_records
  resources :my_bags
  # resources :coupons
  resources :coupon_assign_to_shops
  resources :push_notifications
  get 'coupons_by_shop/:shop_id', to: 'coupon_assign_to_shops#coupons_by_shop'
  
  get 'current_user_details', to: 'addresses#current_user_details'
  get 'get_item_based_on_service', to: 'services_assigns#search'
  get 'date_slot', to:'time_slot_records#date_from_to'
  get 'time_slots', to:'time_slot_records#time_slots'
  get 'get_last_address', to: 'addresses#get_last_address_last'
  put 'get_last_address/:id', to: 'addresses#get_last_address_with_id'
  get 'search_by_city', to:'shops#serch_by_city'
  get 'service_name_item', to:'services#service_name_item'
  get 'search_shops', to:'shops#search_shops'


  # get 'orders_get', to:'orders#get'
  # get 'serch_by_city_and_service_name', to:'shops#serch_using_city_and_service_name'
  # get 'serch_by_city_and_shop_name', to:'shops#serch_using_city_and_shop_name'
  # get 'service_name_based_search', to:'services#service_name_based_search'
  

  post 'users/verify_otp', to: 'users#verify_otp'
  post '/forgot_password', to: 'users#forgot_password'

  post '/reset_password', to: 'users#reset_password'
  post '/resend_otp', to:  'users#resend_otp'
   post '/update_device_token', to: 'push_notifications#update_device_token'

   post 'razor_pay_order_create', to: 'orders#razor_pay_order_create' 
   put 'cancel_order/:id', to:'orders#cancel'
   get 'finished_orders', to: 'orders#finished_orders'
   get 'active_orders', to: 'orders#active_orders'

   get 'get_checkouts_by_shop', to: 'checkouts#get_checkouts_by_shop'


   put '/mark_as_read', to: 'push_notifications#mark_as_read'
   put '/notifications_allow', to: 'notifications#check_allow'

   post 'send_otp_for_new', to: 'users#send_update_otp'
   post 'verify_otp_for_new', to: 'users#verify_update_otp'


end
