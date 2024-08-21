class RenameMobileNumberToPhoneNumberInOtps < ActiveRecord::Migration[6.1]
  def change
     rename_column :otps, :mobile_number, :phone_number
  end
end
