class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|

      t.string :first_name
      t.string :last_name
      t.string :full_phone_number
      t.integer :country_code
      t.bigint :phone_number
      t.string :email
      t.boolean :activated, default: false
      t.boolean :email_verified, default: false
      t.boolean :mobile_verified, default: false
      t.string :device_id
      t.text :unique_auth_id
      t.string :password_digest
      t.string :type
      t.string :username
      t.boolean :is_blacklisted, default: false
      t.string :platform
      t.string :gender
      t.boolean :two_factor_auth, default: false
      t.datetime :suspend_until
      t.date :date_of_birth
      t.boolean :whatsapp_communication, default: false
      t.string :full_name


      t.timestamps
    end
  end
end
