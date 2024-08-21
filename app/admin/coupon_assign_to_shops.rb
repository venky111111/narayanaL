ActiveAdmin.register CouponAssignToShop do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params  shop_id: [], coupon_id: []
   # permit_params  :coupon_code_id, :shop_id
  permit_params :coupon_code_id, shop_ids: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:shop_id, :coupon_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


   index do
    selectable_column
    id_column
  

   
    column 'Coupon Codes' do |coupon_assign_to_shop|
      coupon_assign_to_shop.coupon_codes.pluck(:code_name).join(", ")
    end
    column 'Shops' do |coupon_assign_to_shop|
     
      coupon_assign_to_shop.shops.pluck(:shop_name).join(", ")
    end
   
    actions
  end



   form do |f|
    f.inputs do
      f.input :coupon_code_id, as: :select, collection: CouponCode.all.pluck(:code_name, :id), multiple: true
      f.input :shop_ids, as: :select, collection: Shop.all.pluck(:shop_name, :id), multiple: true
     
    end
    f.actions
  end

  controller do

      def create
        shop_ids = params[:coupon_assign_to_shop][:shop_ids]
        coupon_code_ids = params[:coupon_assign_to_shop][:coupon_code_id]
        coupon_assign_to_shop = CouponAssignToShop.new
        coupon_assign_to_shop.shop_ids = shop_ids
        coupon_assign_to_shop.coupon_code_ids = coupon_code_ids
        # binding.pry

        if coupon_assign_to_shop.save
          redirect_to admin_coupon_assign_to_shops_path, notice: 'Coupon Assign To Shop was successfully created.'
        else
          redirect_to admin_coupon_assign_to_shops_path, alert: 'Coupon already Assign to these shops.'
        end
      end

      def update
        shop_ids = params[:coupon_assign_to_shop][:shop_ids]
        coupon_code_ids = params[:coupon_assign_to_shop][:coupon_code_id]

        coupon_assign_to_shop = CouponAssignToShop.find(params[:id])

        shop_ids.each do |shop_id|
          coupon_code_ids.each do |coupon_code_id|
            if CouponAssignToShop.joins(:shops, :coupon_codes)
                                 .where(shops: { id: shop_id }, coupon_codes: { id: coupon_code_id })
                                 .where.not(id: coupon_assign_to_shop.id)
                                 .exists?
             
              flash.now[:alert] = 'Coupon already assigned to these shops.'
              render :edit and return
            end
          end
        end

        coupon_assign_to_shop.shop_ids = shop_ids
        coupon_assign_to_shop.coupon_code_ids = coupon_code_ids

         coupon_assign_to_shop.save
          redirect_to admin_coupon_assign_to_shops_path, notice: 'Coupon Assign To Shop was successfully updated.'
       
      end

  end
end
