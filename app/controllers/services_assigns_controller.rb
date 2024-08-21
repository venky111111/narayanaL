class ServicesAssignsController < ApplicationController

  def create
    @price = ServicesAssign.new(price_params)
    if @price.save
      render json: @price, status: :created
    else
      render json: @price.errors, status: :unprocessable_entity
    end
  end

  def search
  
  @services_assign = ServicesAssign.joins(:item).find_by(service_id: params[:service_id], items: { item_name: params[:item_name] })
   if @services_assign
    render json: {
      item_name: @services_assign.item.item_name,
      price: @services_assign.price
    }, status: :ok
  else
    render json: { error: 'Item not found' }, status: :not_found
  end
  end

private

	def price_params
		params.permit(:shop_id, :item_id, :price, :service_id)
	end
end
