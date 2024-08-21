class PushNotificationSerializer < ActiveModel::Serializer
  attributes :id, :headings, :contents, :notification_type_id, :created_at, :updated_at, :is_read
end
