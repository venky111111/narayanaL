class PushNotification < ApplicationRecord

	
  belongs_to :user

	after_create :send_notification

  scope :unread, -> {where(is_read: false)}
  
  def mark_as_read!
    update(is_read: true)
  end  

  
  def send_notification

  
      @user = User.find_by_id(self.user_id)
        
     registration_ids =  NotificationDevice.where(user_id: @user.id).pluck(:device_token)

          options = {
          priority: 'high',
          notification: {
            title: headings,
          
            body: contents,
            sound: 'default'       
          }
        }

            fcm = FCM.new('AAAAO0uGhd8:APA91bE4bQXfVJCII1XjpY6HKd4bqKsbNlQC2Ej79z68cxlPCIj_1awt53jA0g_w2wEo6x7tBPttERlkHqxXregjSBcuY2ri9v2xPYwpD0DcMfjB4yfbic8e7bxhLJ5hZAalNFI-hOLv')
         
        response = fcm.send(registration_ids, options)
   
    end
end
