class CheckoutsController < ApplicationController

  before_action :authorize_request

def index
    checkouts = Checkout.where(user_id: @current_user.id).all
    checkouts_data = checkouts.map do |checkout|
      checkout_data = checkout.as_json
      checkout_data["pickup_date"] = checkout.pickup_date.strftime("%d/%m/%Y") if checkout.pickup_date
      checkout_data["delivery_date"] = checkout.delivery_date.strftime("%d/%m/%Y") if checkout.delivery_date
      checkout_data["shop_name"] = checkout.shop.shop_name if checkout.shop

      checkout_data["total_services"] = checkout.total_services.map do |service|
        service_id = service["service_id"]
        service_record = Service.find(service_id)

        {
          service_id: service_id,
          service_name: service_record.service_name,
          items: service["items"].map do |item|
            {
              item_id: item["item_id"],
              item_name: item["item_name"],
              quantity: item["quantity"],
              price_per_item: item["price_per_item"],
              total_price: item["total_price"]
            }
          end
        }
      end

      checkout_data["total"] = checkout.total
      checkout_data["discount"] = checkout.discount || 0
      checkout_data["total_after_discount"] = checkout.total_after_discount || checkout.total
      checkout_data["coupon_code"] = checkout.coupon_code

      checkout_data
    end

    render json: { data: checkouts_data }, status: :ok
  end

def show
  @order = Checkout.find(params[:id])
  order_data = @order.as_json
  order_data["shop_name"] = @order.shop.shop_name if @order.shop
  order_data["total_services"] = @order.total_services.map do |service|
    {
      service_id: service["service_id"],
      items: service["items"].map do |item|
        {
          item_id: item["item_id"],
          item_id: item["item_name"],

          quantity: item["quantity"],
          price_per_item: item["price_per_item"],
          total_price: item["total_price"]
        }
      end
    }
  end

  render json: order_data, status: :ok
end


def create  

  params.merge!(user_id: @current_user.id) if params.present?
  shop = Shop.find(params[:shop_id])
  items_params = params[:items]
  pickup_date = Date.today
  delivery_date = pickup_date + 4.days
  orders = []

  total_services = []
  grand_total = 0
  params[:services].each do |service_params|
    service_id = service_params[:service_id]
    service = Service.find(service_id)

    total_price = 0
    items_quantities = []

    service_params[:items].each do |item|
      item_id = item[:item_id]
      quantity = item[:quantity]
      item_record = Item.find(item_id)
      price_record = ServicesAssign.find_by(shop: shop, service: service, item: item_record)

      if price_record
        total_price += price_record.price * quantity
        partial_price = price_record.price * quantity

        items_quantities << { item_id: item_id, item_name: item_record.item_name, quantity: quantity, price_per_item: price_record.price, total_price: partial_price }
        partial_price = 0
      else
        render json: { error: "Price not found for item ID #{item_id} with the given shop and service" }, status: :not_found
      end
    end

    total_services << { service_id: service_id, service_name: service.service_name, items: items_quantities }
    grand_total += total_price
  end

  checkout = Checkout.new(
    shop_id: shop.id,
    user_id: @current_user.id,
    total_services: total_services,
    total: grand_total,
    pickup_date: pickup_date,
    delivery_date: delivery_date
    )

  
  if checkout.save
      checkout_data = checkout.as_json
    checkout_data["pickup_date"] = checkout.pickup_date.strftime("%d/%m/%Y") if checkout.pickup_date
    checkout_data["delivery_date"] = checkout.delivery_date.strftime("%d/%m/%Y") if checkout.delivery_date
  
    render json: { checkout: checkout_data }, each_serializer: CheckoutSerializer, status: :created
  else
    render json: { messages: checkout.errors.full_messages }, status: :ok
  end
end
 
 def update

  checkout = Checkout.find_by(id: params[:id])
  return render json: { error: 'Checkout not found' }, status: :not_found unless checkout

  pickup_date = params[:pickup_date]
  coupon_confetti = params[:coupon_confetti]
  shop = Shop.find_by(id: params[:shop_id])
  return render json: { error: 'Shop not found' }, status: :not_found unless shop

  parsed_pickup_date = Date.parse(pickup_date) rescue nil
  return render json: { error: 'Invalid pickup date' }, status: :unprocessable_entity unless parsed_pickup_date

  delivery_date = parsed_pickup_date + 4.days
  coupon_code_name = params[:code_name]

  total_services = []
  grand_total = 0

  params[:services].each do |service_params|
    service_id = service_params[:service_id]
    service = Service.find_by(id: service_id)
    return render json: { error: 'Service not found' }, status: :not_found if service.nil?

    total_price = 0
    items_quantities = []

    service_params[:items].each do |item|
      item_id = item[:item_id]
      quantity = item[:quantity]
      item_record = Item.find_by(id: item_id)
      return render json: { error: 'Item not found' }, status: :not_found if item_record.nil?

      price_record = ServicesAssign.find_by(shop: shop, service: service, item: item_record)
      if price_record
        total_price += price_record.price * quantity
        items_quantities << {
          item_id: item_id,
          item_name: item_record.item_name,
          quantity: quantity,
          price_per_item: price_record.price,
          total_price: price_record.price * quantity
        }
      else
        return render json: { error: "Price not found for item ID #{item_id} with the given shop and service" }, status: :not_found
      end
    end

    total_services << { service_id: service_id, items: items_quantities }
    grand_total += total_price
  end

  total = grand_total
  discount = 0
  valid_coupon_code = nil

  if coupon_code_name.present?
    coupon = CouponCode.find_by(code_name: coupon_code_name)
    if coupon.nil? || coupon.expires_at < Time.current || coupon.starting_at > Time.current
      valid_coupon_code = nil
    else
      if coupon.customer_type == 'New user' && @current_user.orders.exists?
        return render json: { error: 'This coupon is for new users only' }, status: :unprocessable_entity
      end

      unless coupon.shops.include?(shop)
        return render json: { error: 'Coupon code is invalid for this shop' }, status: :unprocessable_entity
      end

      if grand_total >= coupon.min_order_value
        discount = [grand_total * (coupon.coupon_discount / 100.0), coupon.max_discount].min
        grand_total -= discount
        valid_coupon_code = coupon_code_name
      else
        return render json: { error: "Order value below coupon's minimum requirement." }, status: :unprocessable_entity
      end
    end
  end

  if pickup_date.present? && Date.parse(pickup_date) < Date.today
    pickup_date = Date.today.strftime("%Y-%m-%d")
  else
    pickup_date = pickup_date
  end

  checkout.update(
    shop_id: shop.id,
    user_id: @current_user.id,
    total_services: total_services,
    pickup_date: pickup_date,
    delivery_date: delivery_date,
    discount: discount,
    total_after_discount: grand_total,
    coupon_code: valid_coupon_code,
    coupon_confetti: coupon_confetti
  )

  if checkout.save
    checkout_data = checkout.as_json
    checkout_data["pickup_date"] = checkout.pickup_date.strftime("%d/%m/%Y") if checkout.pickup_date
    checkout_data["delivery_date"] = checkout.delivery_date.strftime("%d/%m/%Y") if checkout.delivery_date

     
    # Add the custom attributes
    checkout_data["total"] = total
   
    checkout_data["coupon_code"] = valid_coupon_code
    render json: { checkout: checkout_data }, status: :ok
  else
    render json: { error: checkout.errors.full_messages }, status: :unprocessable_entity
  end
end     

def destroy
  
  checkout = Checkout.find_by(id: params[:id])

  if checkout
    checkout.destroy
    render json: { message: 'Checkout successfully deleted' }, status: :ok
  else
    render json: { error: 'Checkout not found' }, status: :not_found
  end
end

def get_checkouts_by_shop
    shop_id = params[:shop_id]
    
    checkouts = Checkout.where(shop_id: shop_id)
    if checkouts.present?
      render json: { data: checkouts }, status: :ok
    else
      render json: { message: "No checkouts found for shop ID #{shop_id}" }, status: :not_found
    end
end



  private 

def service_params
  params.permit(:user_id, :shop_id, :service_id, items: [:item_id, :quantity])
end
end
