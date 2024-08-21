class ServicesController < ApplicationController

	def index
    @my_bags = Service.all
    render json: @my_bags
    
  end

  def service_name_based_search
    service_name = params[:service_name]
    services = Service.where(service_name: service_name)
     if services.present?
        render json: { service_name: services }, status: :ok
    else
      render json: { error: "Service with name not found" }, status: :not_found
    end
  end

def service_name_item
  
  service_name = params[:service_name]
  services = Service.includes(:items).where(service_name: service_name)
  
  if services.present?
   
    service_items = services.map do |service|
      {
        items: service.items.pluck(:item_name)
      }
    end

    render json: service_items, status: :ok
  else
    render json: { error: "Service with name not found" }, status: :not_found
  end
end
 

  def create
    created_services = []

    service_params[:item_id].each do |item_id|
      @service = Service.new(shop_id: service_params[:shop_id], item_id: item_id, service_name: service_params[:service_name])
      if @service.save
        created_services << @service
      else
        render json: @service.errors, status: :unprocessable_entity
       return
      end
    end

    render json: { message: "Services created successfully", services: created_services }, status: :ok
  end



private 

	def service_params
		params.permit(:shop_id, :service_name, item_id: [])
	end
end
