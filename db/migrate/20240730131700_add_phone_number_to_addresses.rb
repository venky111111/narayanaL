class AddPhoneNumberToAddresses < ActiveRecord::Migration[6.1]
  def change
     add_column :addresses, :phone_number, :bigint
  end
end
