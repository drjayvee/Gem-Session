class Project < ApplicationRecord
  belongs_to :user

  validates :prompt, presence: true
  validates :homepage_url, allow_blank: true, format: { with: URI.regexp }
end
