class OrdersController < ApplicationController

	before_action :authorize_request
  before_action :find_order, only: [:show,:update, :cancel]

 
 def active_orders
  @active_orders = @current_user.orders.where(status: ['Order placed', 'Pickup', 'Servicing', 'Shipping order'])
  render json: format_orders(@active_orders), status: :ok
end

def finished_orders
  @finished_orders = @current_user.orders.where(status: ['Order delivered', 'Order cancelled'])
  render json: format_orders(@finished_orders), status: :ok
end

def index
  @orders = @current_user.orders
  render json: format_orders(@orders), status: :ok
end

  def show
    render json: { order: format_order(@order) }, status: :ok
  end


def razor_pay_order_create
	
  amount = params[:amount].to_i  # Ensure amount is converted to an integer
  pickup_date = params[:pickup_date]
  shop_id = params[:shop_id]  # Note: params[:shop_id] should be a string or symbol
  services = params[:services]
  currency = 'INR'

  # Create order in Razorpay without sending order_id
   Razorpay.setup('rzp_test_M2Sb0gJt4nyRVA', 'YHxmg5qi27t0G1mX3h94QUvD')
  razorpay_order = Razorpay::Order.create(amount: amount, currency: currency)
  

  if razorpay_order.present? && razorpay_order.id.present?
    render json: {
      order_id: razorpay_order.id,
      amount: amount,
      pickup_date: pickup_date,
      shop_id: shop_id,
      services: services
    }
  else
    render json: { errors: "Failed to create Razorpay order" }, status: :unprocessable_entity
  end
end


def create
  shop_id = params[:shop_id]
  pickup_date = params[:pickup_date]
  delivery_date = params[:delivery_date]
  type = params[:type]
  amount = params[:amount]
  razorpay_order_id = params[:razorpay_order_id]
  services_params = params[:services]
  coupon_code_name = params[:code_name]

  default_address = @current_user.addresses.find_by(default: true)
  shop = Shop.find(shop_id)
  user_id = @current_user.id

  total_services = []
  grand_total = 0

  services_params.each do |service_params|
    service_id = service_params[:service_id]
    service = Service.find(service_id)
    service_items = []

    service_params[:items].each do |item|
      item_id = item[:item_id]
      quantity = item[:quantity]
      item_record = Item.find(item_id)
      price_record = ServicesAssign.find_by(shop: shop, service: service, item: item_record)

      if price_record
        total_price = price_record.price * quantity
        grand_total += total_price
        service_items << {
          item_id: item_id,
          item_name: item_record.item_name,
          quantity: quantity,
          price_per_item: price_record.price,
          total_price: total_price
        }
      else
        return render json: { error: "Price not found for item ID #{item_id} with the given shop and service" }, status: :not_found
      end
    end

    total_services << {
      service_id: service_id,
      service_name: service.service_name,
      items: service_items
    }
  end

  total = grand_total
  discount = 0

 
  if coupon_code_name.present?
    coupon = CouponCode.find_by(code_name: coupon_code_name)

    if coupon.nil?
      return render json: { error: "Coupon not found" }, status: :not_found
    end

   
    unless coupon.shops.include?(shop)
      return render json: { messages: "coupon code is invalid" }, status: :ok
    end

    if coupon.starting_at <= Time.now && coupon.expires_at >= Time.now
      if grand_total >= coupon.min_order_value
        discount = [grand_total * (coupon.coupon_discount / 100.0), coupon.max_discount].min
        grand_total -= discount
      else
        return render json: { error: "Order value below coupon's minimum requirement." }, status: :unprocessable_entity
      end
    else
      return render json: { error: "Coupon is not valid or has expired" }, status: :unprocessable_entity
    end
  end

  case type
  when "CashOnDelivery"
    track_id = "cod_#{SecureRandom.hex(10)}"

    order_attributes = {
      user_id: user_id,
      shop_id: shop_id,
      pickup_date: pickup_date,
      delivery_date: delivery_date,
      grand_total: grand_total,
      total_services: total_services,
      type: type,
      razorpay_order_id: razorpay_order_id,
      amount: amount,
      track_id: track_id,
      address_id: default_address.id,
      payment_status: 'pending'
    }
    @order = Order.new(order_attributes)
  when "OnlinePayment"
    track_id = "OP_#{SecureRandom.hex(10)}"

    razorpay_payment_id = params[:razorpay_payment_id]
    razorpay_order_id = params[:razorpay_order_id]
    razorpay_signature = params[:razorpay_signature]

    order_attributes = {
      user_id: user_id,
      shop_id: shop_id,
      pickup_date: pickup_date,
      delivery_date: delivery_date,
      grand_total: grand_total,
      total_services: total_services,
      type: type,
      amount: amount,
      track_id: track_id,
      razorpay_payment_id: razorpay_payment_id,
      razorpay_order_id: razorpay_order_id,
      razorpay_signature: razorpay_signature,
      address_id: default_address.id,
      payment_status: razorpay_signature.present? ? 'Paid' : 'pending'
    }
    @order = Order.new(order_attributes)
  else
    return render json: { error: "Invalid payment type" }, status: :unprocessable_entity
  end

  if @order.save
    PushNotification.create(
      headings: 'Completed product buy',
      contents: "#{@current_user.full_name} has ordered successfully.",
      user_id: @current_user.id,
      action_needed: true,
      notification_type: 'Order placed successfully',
      notification_type_id: @order.id
    )

    @current_user.checkout.destroy if @current_user.checkout.present?

    render json: {
      id: @order.id,
      user_id: @order.user_id,
      razorpay_order_id: @order.razorpay_order_id,
      shop_id: @order.shop_id,
      pickup_date: @order.pickup_date,
      delivery_date: @order.delivery_date,
      total: total,
      discount: discount,
      total_after_discount: grand_total,
      total_services: @order.total_services,
      type: @order.type,
      amount: @order.amount,
      track_id: @order.track_id,
      razorpay_payment_id: @order.razorpay_payment_id,
      razorpay_order_id: @order.razorpay_order_id,
      razorpay_signature: @order.razorpay_signature,
      created_at: @order.created_at,
      updated_at: @order.updated_at,
      address_id: @order.address_id,
      payment_status: @order.payment_status
    }, status: :created
  else
    render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
  end
end

 def update
    if params[:pickup_date].present?
      @order.pickup_date = params[:pickup_date]
      @order.delivery_date = @order.pickup_date + 4.days
    end

    if params[:type] == "OnlinePayment"
      @order.type = "OnlinePayment"
      @order.razorpay_payment_id = params[:razorpay_payment_id]
      @order.razorpay_order_id = params[:razorpay_order_id]
      @order.razorpay_signature = params[:razorpay_signature]

      @order.payment_status = @order.razorpay_signature.present? ? 'Paid' : 'pending'
      
    end

    if @order.save
       order_data = @order.as_json
        order_data["pickup_date"] = @order.pickup_date.strftime("%d/%m/%Y") if @order.pickup_date.present?
        order_data["delivery_date"] = @order.delivery_date.strftime("%d/%m/%Y") if @order.delivery_date.present?

      render json: { message: 'Order updated successfully', order: order_data }, status: :ok
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end


def cancel

  if params[:order_cancel_reason].present?
    if @order.update(order_cancel_reason: params[:order_cancel_reason], status: 'Order cancelled')
      render json: { message: 'Order has been successfully cancelled', order: @order }, status: :ok
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  else
    render json: { error: 'Please select a reason for cancellation' }, status: :unprocessable_entity
  end

end





private

	def service_params
		params.permit(:user_id, :piceup_date, :shop_id, :type, :amount, :razorpay_order_id, :razorpay_payment_id, :razorpay_signature, :currency, :status, :track_id, :address_id, :order_cancel_reason,:service_id, items: [:item_id, :quantity], total_services: [])
	end

  def find_order
    @order = Order.find(params[:id])
  end
  
  def format_orders(orders)
    orders.map { |order| format_order(order) }
  end

  # def format_order(order)
  #   order_data = order.as_json
  #   order_data["pickup_date"] = order.pickup_date.strftime("%d/%m/%Y") if order.pickup_date
  #   order_data["delivery_date"] = order.delivery_date.strftime("%d/%m/%Y") if order.delivery_date
  #   order_data["pickup"] = order.pickup.strftime("%d/%m/%Y") if order.pickup
  #   order_data["servicing"] = order.servicing.strftime("%d/%m/%Y") if order.servicing
  #   order_data["shipping_order"] = order.shipping_order.strftime("%d/%m/%Y") if order.shipping_order
  #   order_data["order_delivered"] = order.order_delivered.strftime("%d/%m/%Y") if order.order_delivered
  #    order_data["created_at"] = order.created_at.strftime("%d/%m/%Y") if order.created_at
  #   order_data["total_services"] = (order.total_services || []).map do |service|
  #     service_record = Service.find_by(id: service["service_id"])
  #     next unless service_record

  #     {
  #       service_id: service["service_id"],
  #       service_name: service_record.service_name,
  #       items: (service["items"] || []).map do |item|
  #         {
  #           item_id: item["item_id"],
  #           item_name: item["item_name"],
  #           quantity: item["quantity"],
  #           price_per_item: item["price_per_item"],
  #           total_price: item["total_price"]
  #         }
  #       end
  #     }
  #   end.compact
  #   order_data["type"] = order.type
  #   order_data["order_cancel_reason"] = order.order_cancel_reason
  #   order_data
  # end


# def format_order(order)
#   order_data = order.as_json

#   # Format dates
#   order_data["pickup_date"] = order.pickup_date.strftime("%d/%m/%Y") if order.pickup_date
#   order_data["delivery_date"] = order.delivery_date.strftime("%d/%m/%Y") if order.delivery_date
#   order_data["pickup"] = order.pickup.strftime("%d/%m/%Y") if order.pickup
#   order_data["servicing"] = order.servicing.strftime("%d/%m/%Y") if order.servicing
#   order_data["shipping_order"] = order.shipping_order.strftime("%d/%m/%Y") if order.shipping_order
#   order_data["order_delivered"] = order.order_delivered.strftime("%d/%m/%Y") if order.order_delivered
#   order_data["created_at"] = order.created_at.strftime("%d/%m/%Y") if order.created_at

#   # Calculate total, discount, and total_after_discount
#   total = order.total_services.sum do |service|
#     service["items"].sum { |item| item["total_price"] }
#   end

#   discount = total - order.grand_total
#   total_after_discount = order.grand_total

#   # Include these fields in the response
#   order_data["total"] = total
#   order_data["discount"] = discount
#   order_data["total_after_discount"] = total_after_discount

#   # Include total_services with formatted service and item details
#   order_data["total_services"] = (order.total_services || []).map do |service|
#     service_record = Service.find_by(id: service["service_id"])
#     next unless service_record

#     {
#       service_id: service["service_id"],
#       service_name: service_record.service_name,
#       items: (service["items"] || []).map do |item|
#         {
#           item_id: item["item_id"],
#           item_name: item["item_name"],
#           quantity: item["quantity"],
#           price_per_item: item["price_per_item"],
#           total_price: item["total_price"]
#         }
#       end
#     }
#   end.compact

#   shop = Shop.find_by(id: order.shop_id)
#   order_data["shop_name"] = shop.shop_name if shop

#   order_data["type"] = order.type
#   order_data["order_cancel_reason"] = order.order_cancel_reason
#   order_data
# end

def format_order(order)
  order_data = order.as_json
  order_data["pickup_date"] = order.pickup_date.strftime("%d/%m/%Y") if order.pickup_date
  order_data["delivery_date"] = order.delivery_date.strftime("%d/%m/%Y") if order.delivery_date
  order_data["pickup"] = order.pickup.strftime("%d/%m/%Y") if order.pickup
  order_data["servicing"] = order.servicing.strftime("%d/%m/%Y") if order.servicing
  order_data["shipping_order"] = order.shipping_order.strftime("%d/%m/%Y") if order.shipping_order
  order_data["order_delivered"] = order.order_delivered.strftime("%d/%m/%Y") if order.order_delivered
  order_data["created_at"] = order.created_at.strftime("%d/%m/%Y") if order.created_at

  # Calculate total, discount, and total_after_discount
  total = order.total_services.sum do |service|
    service["items"].sum { |item| item["total_price"] }
  end

  grand_total = order.grand_total || 0
  discount = total - grand_total
  total_after_discount = grand_total

  # Include these fields in the response
  order_data["total"] = total
  order_data["discount"] = discount
  order_data["total_after_discount"] = total_after_discount

  # Include total_services with formatted service and item details
  order_data["total_services"] = (order.total_services || []).map do |service|
    service_record = Service.find_by(id: service["service_id"])
    next unless service_record

    {
      service_id: service["service_id"],
      service_name: service_record.service_name,
      items: (service["items"] || []).map do |item|
        {
          item_id: item["item_id"],
          item_name: item["item_name"],
          quantity: item["quantity"],
          price_per_item: item["price_per_item"],
          total_price: item["total_price"]
        }
      end
    }
  end.compact

  shop = Shop.find_by(id: order.shop_id)
  order_data["shop_name"] = shop.shop_name if shop

  order_data["type"] = order.type
  order_data["order_cancel_reason"] = order.order_cancel_reason
  order_data
end

end
