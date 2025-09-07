class User < ApplicationRecord
  class NarcissismError < StandardError; end
  class SpoilerError < StandardError; end

  has_secure_password
  has_secure_token :confirmation_token

  has_many :sessions, dependent: :destroy
  has_many :projects
  has_many :project_likes, dependent: :destroy
  has_many :liked_projects, through: :project_likes, source: :project

  validates :name, presence: true, allow_nil: false, uniqueness: true, length: { minimum: 3, maximum: 44 }
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, format: URI::MailTo::EMAIL_REGEXP, uniqueness: true

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update! confirmation_token: nil, confirmed_at: Time.now
  end

  def like(project)
    raise NarcissismError if projects.include? project
    raise SpoilerError, "This project isn't ready for the spotlight yet" unless project.published?
    return if liked_projects.include? project

    liked_projects << project
  end

  def like?(project)
    liked_projects.include? project
  end

  def unlike(project)
    liked_projects.delete project
  end
end
