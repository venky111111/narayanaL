class User < ApplicationRecord

	 has_secure_password
  validates :email, uniqueness: true, presence: true, if: -> { self.type == 'EmailUser' }
  validates :phone_number, uniqueness: true, presence: true, if: -> { self.type == 'MobileUser' }
  validates :agree, presence: true
  has_many :addresses
  has_one :checkout, dependent: :destroy 
  validate :password_length_for_non_social_users

  has_many :notification_devices
  has_many :orders
  has_many :push_notifications





  private

  def password_length_for_non_social_users
    if !social_user? && (new_record? || !password.nil?)
      errors.add(:password, 'is too short (minimum is 6 characters)') if password.length < 6
    end
  end

  def social_user?
    self.is_a?(SocialUser)
  end


end
