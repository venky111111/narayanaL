class AddOtpResendAttemptsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp_resend_attempts, :integer, default: 0
  end
end
