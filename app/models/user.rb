class User < ApplicationRecord
  has_secure_password
  has_secure_token :confirmation_token

  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, format: URI::MailTo::EMAIL_REGEXP, uniqueness: true

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update! confirmation_token: nil, confirmed_at: Time.now
  end
end
