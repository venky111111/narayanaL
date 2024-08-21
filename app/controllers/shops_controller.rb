class ShopsController < ApplicationController

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      render json: @shop, serializer: ShopSerializer, status: :created
    else
      render json: @shop.errors, status: :unprocessable_entity
    end
  end

  def show
 
    @shop = Shop.find_by(id: params[:id])
    if @shop
    services_with_items = @shop.services.uniq.map do |service|
      {
        service_id: service.id,
        service_name: service.service_name,
        
          items: service.items.uniq.map do |item|
          
          {
            item_id: item.id,
            item_name: item.item_name,
              item_price: item.services_assigns.find_by(service_id: service.id)&.price
            
          }
        end
      }
    end

    render json: {
      shop_id: @shop.id,
      shop_name: @shop.shop_name,
      shop_location: @shop.city,
      services: services_with_items
    }, status: :ok
  else
    render json: { message: "Shop not found" }, status: :not_found
  end

  end

def serch_by_city
   if params[:city].present?
   
      @shop_results = Shop.where("city ILIKE ?", "%#{params[:city]}%")
      render json: @shop_results, each_serializer: ShopSerializer, status: :ok
    else
      render json: {messages: "no results found with that city"},status: :ok
    end
end




def search_shops
     if params[:city].present? && params[:shop_or_service_name].present?
    city = params[:city]
    shop_or_service_name = params[:shop_or_service_name]

    @results = Shop.where("city ILIKE ?", "%#{city}%")
                   .left_joins(:services)
                   .where("shops.shop_name ILIKE :name OR services.service_name ILIKE :name", name: "%#{shop_or_service_name}%")
                   .distinct

    if @results.present?
      render json: @results, each_serializer: ShopSerializer, include: ['services'], status: :ok
    else
      render json: { messages: ["No results found"] }, status: :ok
    end
  else
    render json: { messages: "No valid search parameters provided" }, status: :unprocessable_entity
  end
end




  
  private

  def shop_params
    params.permit(:shop_name, :city)
  end

end




























# before item and prices relation


# class ShopsController < ApplicationController


# def index
#   # binding.pry
#   # a = Shop.all
#   # render json: a, status: :ok
#   shops = Shop.includes(:services).all
#     render json: shops, include: :services, status: :ok
  
# end

#  def create
#     @shop = Shop.new(shop_params)

#     if @shop.save
#       service_ids = params[:services]  
#       # binding.pry
#       @shop.services << Service.where(id: service_ids) if service_ids.present?
#       # binding.pry
#       render json: @shop, include: :services, status: :created
#     else
#       render json: @shop.errors, status: :unprocessable_entity
#     end
#   end

#   # def serch_by_city
#   #   # binding.pry

#   #   if params[:city].present?
#   #     @shop_results = Shop.where("city LIKE ?", "%#{params[:city]}%")
#   #     # render json: {data: @shop_results},status: :ok
     
#   #   else
#   #     render json: {messages: "no results found with that city"},status: :ok
#   #   end
  
#   # end

#   # def serch_by_service
#   #   # binding.pry

#   #   if params[:city].present?
#   #     @city_results = Shop.where("city LIKE ?", "%#{params[:city]}%")
#   #     render json: {data: @city_results},status: :ok
#   #   else
#   #     render json: {messages: "no results found with that city"},status: :ok
#   #   end
  
#   # end

#   def search_by_city
#     if params[:city].present?
#       @city_results = Shop.includes(:services).where("city LIKE ?", "%#{params[:city]}%")
#       render json: @city_results, include: :services, status: :ok
#     else
#       render json: { messages: "No results found with that city" }, status: :ok
#     end
#   end

#   def search_by_services
#     if params[:service_name].present?
#       @service_name_results = Shop.joins(:services).where("services.service_name LIKE ?", "%#{params[:service_name]}%")
#       render json: @service_name_results, include: :services, status: :ok
#     else
#       render json: { messages: "No results found with that service name" }, status: :ok
#     end
#   end


 

#   private

#   def shop_params
#     params.permit(:shop_name, :image, :house_number, :landmark, :city, :services_name)  
 
#  end


# end

