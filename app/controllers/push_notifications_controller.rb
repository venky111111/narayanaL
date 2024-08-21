class PushNotificationsController < ApplicationController

	before_action :authorize_request

   def index
    push_notifications = @current_user.push_notifications.order(created_at: :desc)
    unread_notification_count = push_notifications.unread.count

    render json: {
      push_notifications: ActiveModel::Serializer::CollectionSerializer.new(push_notifications, each_serializer: PushNotificationSerializer),
      unread_notification_count: unread_notification_count
    }, status: :ok
  end

  def mark_as_read
    notification = PushNotification.find(params[:push_notification_id])
    notification.mark_as_read!
    render json: notification, status: :ok
  end

	def update_device_token
      device_token = params[:device_token]

      if device_token.present?
        notification_device = @current_user.notification_devices.last
        if notification_device
           notification_device.update(device_token: device_token)
        else
          @current_user.notification_devices.create(device_token: device_token)
        end

        render json: { messages: "FCM token updated successfully" }, status: :ok
      else
        render json: { errors: "FCM token is missing" }, status: :unprocessable_entity
      end
  end


end
