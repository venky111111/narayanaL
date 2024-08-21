class CouponAssignToShopsController < ApplicationController


  def coupons_by_shop
    shop = if params[:shop_id]
             Shop.find_by(id: params[:shop_id])
           elsif params[:shop_name]
             Shop.find_by(name: params[:shop_name])
           end

    if shop
      coupons = shop.coupon_codes.where('expires_at > ?', Time.current)
      render json: coupons, status: :ok
    else
      render json: { error: 'Shop not found' }, status: :not_found
    end
  end

private
 
     def coupon_assign_to_shop_params
      params.permit(:coupon_code_id, shop_ids: [])
     end

end
