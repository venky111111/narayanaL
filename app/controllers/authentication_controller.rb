class AuthenticationController < ApplicationController
   before_action :authorize_request, except: :login

def login

  case params[:type]
    when "email_user"
       @user = EmailUser.find_by_email(params[:email]) if params[:email].present?
     
      if @user&.authenticate(params[:password])
        
         token_code_and_message("Login successful.")
      else
        render json: { errors: 'Please enter valid Email/Password' }, status: :unauthorized
      end
       
    when "mobile_user"
       @user = MobileUser.find_by_phone_number(params[:phone_number]) if params[:phone_number].present?
      if @user&.authenticate(params[:password])
          token_code_and_message("Login successful.")
      else
        render json: { errors: 'Please enter valid Phone Number/Password' }, status: :unauthorized
      end 


 when "social_user"
      @user = SocialUser.find_by(email: params[:email])
      
      if @user
        token_code_and_message("Login successful.")
      else
        password = generate_password_from_email(params[:email])
        user_params_with_password = login_params.merge(password_digest: password, activated: true)
        
        @user = SocialUser.new(user_params_with_password)
        @user.update(agree: true)
        if @user.save   
          token_code_and_message("Login successful.")
        else
          render json: { errors: @user.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end 
      end
    end
  end
  private

   def token_code_and_message(message)
    if @user.activated?

         
      token = JsonWebToken.encode(user_id: @user.id)
     

     
      time = Time.now + 24.hours.to_i

    render json: { token: token, email: @user.email, Phone_number: @user.phone_number, first_name: @user.first_name, last_name: @user.last_name,  user_id: @user.id, messages: message  }, status: :ok
    else
      render json: { messages: "Your user has not verified/activated." }, status: :ok
    end
  end
   def generate_password_from_email(email)
    email + "@Laundry"
  end

  def login_params
    params.permit(:email, :password, :phone_number, :uid, :provider,:activated)
  end

end
