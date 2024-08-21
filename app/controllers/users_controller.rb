class UsersController < ApplicationController

	
before_action :authorize_request, except: [:index, :create, :show, :update, :update_contact_info, 
                       :send_email_otp, :send_sms_otp, :verify_otp, :resend_otp, 
                    :forgot_password, :reset_password, :profile_update, :send_update_otp, :verify_update_otp]
 
 
def index
    @users = User.all
    render json: @users, status: :ok
  end

def create
  type = params[:type]

  case type
  when "email_user"
  	@user = EmailUser.new(user_params)

    if @user.save
      otp = rand(1000..9999)
      email_otp = EmailOtp.new(
        otp_expiry: Time.now + 1.minutes,
        otp_number: otp,
        user_id: @user.id
      )

      if email_otp.save
        # userMailer.welcome_email(@user, email_otp).deliver_now
        render json: { messages: "Email OTP sent successfully", user: @user, otp: otp }, status: :ok
      else
   
        render json: { errors: "Failed to save OTP" }, status: :unprocessable_entity
      end
    else

      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      
    end
  when "mobile_user"
  
    @user = MobileUser.new(user_params)
   
    if @user.save
      otp = rand(1000..9999)
      sms_otp = SmsOtp.new(
        otp_expiry: Time.now + 1.minutes,
        otp_number: otp,
        user_id: @user.id
      )
      
      if sms_otp.save
       
        render json: { success: true, messages: 'OTP sent successfully', otp: otp, user: @user }
      else
        render json: { errors: "Failed to save OTP" }, status: :unprocessable_entity
      end
    else
       render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      
    end    
  else
    render json: { errors: "Invalid sign up type" }, status: :unprocessable_entity
  end
end

def update
 
    @user = User.find_by_id(params[:id])

    if @user.update(user_params)
      render json: { messages: "Account details updated successfully", data: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end




def verify_otp
  if params[:user_id].present?
    user = User.find(params[:user_id])
  
    if params[:email].present? && params[:email] == user.email
        otp = EmailOtp.where('user_id = ? and otp_expiry >= ?', user.id, Time.current).last
     
     elsif params[:phone_number].present? && params[:phone_number] == user.phone_number.to_s
      otp = SmsOtp.where('user_id = ? and otp_expiry >= ?', user.id, Time.current).last
    end
    if otp 
      if otp.otp_number == params[:otp]
    
        user.email_verified = true if params[:email].present?
        user.mobile_verified = true if params[:phone_number].present?
        if user.activated = true
        user.save
          render json: { messages: "Your OTP has been verified successfully.", user: user }, status: :ok
        else
          render json: { errors: user.errors.full_messages, message: "test" }, status: :unprocessable_entity
        end
      else
        render json: { messages: "Invalid OTP. Please enter the correct OTP." }, status: :unprocessable_entity
      end
    else 
      render json: { messages: "No record found or otp is expired. Please generate a new OTP." }, status: :unprocessable_entity
    end
  else
    render json: { messages: "Please provide a user ID." }, status: :unprocessable_entity
  end
end


def forgot_password
   
     if params[:email].present?
    user = User.find_by(email: params[:email])

    if user && user.email_verified?
      otp = rand(1000..9999)
      email_otp = EmailOtp.new(
        otp_expiry: Time.now + 1.minutes,
        otp_number: otp,
        user_id: user.id
      )

      if email_otp.save
        
        return render json: { messages: "OTP sent successfully to email.", success: true, otp: otp, user: user }, status: :ok
      else
        return render json: { errors: email_otp.errors.full_messages, success: false }, status: :unprocessable_entity
      end
    else
      return render json: { errors: "Email not verified or user not found.", success: false }, status: :unprocessable_entity
    end
  elsif params[:phone_number].present?
    user = User.find_by(phone_number: params[:phone_number])

    if user && user.mobile_verified?
      otp = rand(1000..9999)
      sms_otp = SmsOtp.new(
        otp_expiry: Time.now + 1.minutes,
        otp_number: otp,
        user_id: user.id
      )

      if sms_otp.save
     
        return render json: { success: true, messages: 'OTP sent successfully to phone number.', otp: otp, user: user }, status: :ok
      else
        return render json: { errors: sms_otp.errors.full_messages, success: false }, status: :unprocessable_entity
      end
    else
      return render json: { errors: "Phone number not verified or user not found.", success: false }, status: :unprocessable_entity
    end
  else
    return render json: { errors: "Email or phone number is missing.", success: false }, status: :unprocessable_entity
  end
end

def resend_otp
  if params[:user_id].present?
    user = User.find_by(id: params[:user_id])

    if user.present?
      # if user.otp_resend_attempts >= 2 
      #   return render json: { messages: "Exceded maximum attempts try after 24 hours." }, status: :unprocessable_entity
      # end

      if params[:email].present? && user.email == params[:email]
        otp_type = :email
      elsif params[:phone_number].present? && user.phone_number.to_s == params[:phone_number]
        otp_type = :phone
      else
        return render json: { errors: "No valid email or phone number provided.", success: false }, status: :unprocessable_entity
      end

      otp = rand(1000..9999)

      if otp_type == :email
        otp_record = EmailOtp.new(
          otp_expiry: Time.now + 1.minutes,
          otp_number: otp,
          user_id: user.id
        )
        method = :welcome_email
      elsif otp_type == :phone
        otp_record = SmsOtp.new(
          otp_expiry: Time.now + 1.minutes,
          otp_number: otp,
          user_id: user.id
        )
       
      end

      if otp_record.save
       
        return render json: { success: true, messages: "OTP sent successfully to #{otp_type == :email ? 'email' : 'phone number'}.", otp: otp }, status: :ok
      else
        return render json: { message: "no user found", errors: otp_record.errors.full_messages, success: false }, status: :unprocessable_entity
      end

    else
      return render json: { errors: "Account not found.", success: false }, status: :not_found
    end
  else
    return render json: { errors: "Account ID is missing.", success: false }, status: :unprocessable_entity
  end
end



def reset_password
  if params[:password] == params[:new_password]
    user = User.find(params[:user_id]) # Assuming you still have a user_id parameter
    if user.update(password: params[:password])
      render json: { messages: 'Password updated successfully' }, status: :ok
    else
      render json: { messages: 'Failed to update password', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  else
    render json: { messages: 'Please provide a password' }, status: :unprocessable_entity
  end
end 




def send_update_otp
  @user = User.find(params[:user_id])
  # binding.pry

  if params[:email].present?
    otp = rand(1000..9999)
    email_otp = EmailOtp.new(
      otp_expiry: Time.now + 10.minutes,
      otp_number: otp,
      user_id: @user.id
    )
    
    if email_otp.save
      # Send OTP to new email (implement your mailer here)
      render json: { messages: "OTP sent successfully to new email.", otp: otp }, status: :ok
    else
      render json: { errors: email_otp.errors.full_messages }, status: :unprocessable_entity
    end
  elsif params[:phone_number].present?
    otp = rand(1000..9999)
    sms_otp = SmsOtp.new(
      otp_expiry: Time.now + 10.minutes,
      otp_number: otp,
      user_id: @user.id
    )
    
    if sms_otp.save
      # Send OTP to new phone number (implement your SMS sending logic here)
      render json: { messages: "OTP sent successfully to new phone number.", otp: otp }, status: :ok
    else
      render json: { errors: sms_otp.errors.full_messages }, status: :unprocessable_entity
    end
  else
    render json: { errors: "New email or phone number is required." }, status: :unprocessable_entity
  end
end


def verify_update_otp
  @user = User.find(params[:user_id])

  if params[:email].present?
    otp = EmailOtp.where('user_id = ? and otp_expiry >= ?', @user.id, Time.current).last
    if otp && otp.otp_number == params[:otp]
      @user.update(email: params[:email], email_verified: true)
      render json: { messages: "Email updated successfully.", user: @user }, status: :ok
    else
      render json: { errors: "Invalid OTP or OTP expired." }, status: :unprocessable_entity
    end
  elsif params[:phone_number].present?
    otp = SmsOtp.where('user_id = ? and otp_expiry >= ?', @user.id, Time.current).last
    if otp && otp.otp_number == params[:otp]
    # binding.pry
      if @user.update(phone_number: params[:phone_number], mobile_verified: true)
      render json: { messages: "Phone number updated successfully.", user: @user }, status: :ok
    else
      render json: {messages: "not updated"}
    end
    else
      render json: { errors: "Invalid OTP or OTP expired." }, status: :unprocessable_entity
    end
  else
    render json: { errors: "New email or phone number is required." }, status: :unprocessable_entity
  end
end
 

  private

  def user_params
    params.permit(
      :full_name, :email, :password, :password_confirmation, :phone_number,  :uid, :agree, :profile_pic_id
    )
  end

end
