class AddressesController < ApplicationController

	before_action :authorize_request

    def current_user_details
      @user_details = @current_user
      render json: { data: @user_details }

    end

    def index
        @addresses = Address.where(user_id: @current_user.id).order(created_at: :desc)
        render json: { data: @addresses }
      end

    def get_last_address_last
        @address = Address.where(user_id: @current_user.id, default: true).last
        
        @address ||= Address.where(user_id: @current_user.id).last
        render json: { data: @address }
    end

    def get_last_address_with_id
      @address = Address.find_by(id: params[:id])
       
      if @address.update(address_params)
         address_params[:default] == true
          Address.where(user_id: @current_user.id).where.not(id: @address.id).update_all(default: false)
          @address = Address.where(user_id: @current_user.id, default: true).last
          
          @address ||= Address.where(user_id: @current_user.id).last
          render json: { data: @address }
      else
        render json: @address.errors, status: :unprocessable_entity
      end     
    end

    def show
     @address = Address.find_by(id: params[:id])
      if @address
        render json: { data: @address }, status: :ok
      else
        render json: { errors: "Address not found" }, status: :not_found
      end
    end

    def create
    params.merge!(user_id: @current_user.id) if params.present?
      @address = Address.new(address_params)
      
      if @address.save
        @address.update(default: true)
        Address.where(user_id: @current_user.id).where.not(id: @address.id).update_all(default: false)
        render json: { data: @address, message: 'Address created successfully' }, status: :ok
      else
        render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
      end
    end


    def update
        params.merge!(user_id: @current_user.id) if params.present?
        
         @address = Address.find_by(id: params[:id])
        
        if @address.update(address_params)
         render json: { data: @address, messages: 'address updated successfully'}, status: :ok
        else
          render json: @address.errors, status: :unprocessable_entity
        end
    end


    def destroy
        @address = Address.find_by_id(params[:id])
       if @address.destroy
          render json: { messages: 'record deleted sucessfully', data: @address} , status: :ok
        else
          render json: { errors: "Record not found or deleted" },
                 status: :unprocessable_entity
       end    
    end


  private




def address_params
    params.permit(:user_id,  :house_number, :street, :landmark,:default, :address_type, :direction_to_reach, :city, :phone_number)
end



end
