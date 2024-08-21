class CreateOtps < ActiveRecord::Migration[6.1]
  def change
    create_table :otps do |t|
      t.integer :user_id
      t.string :otp_number
      t.datetime :otp_expiry
      t.string :type
      t.string :email
      t.string :mobile_number

      t.timestamps
    end
  end
end
