class ItemsController < ApplicationController

	def create
    @item = Item.new(item_params)
    if @item.save
      render json: @item, serializer: ItemSerializer, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end


  

  

  
  
  private

  	def item_params
		params.permit(:item_name)
	end
end
