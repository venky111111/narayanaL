class CreateNotificationDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :notification_devices do |t|

      t.string :device_token
      t.integer :user_id

      t.timestamps
    end
  end
end
