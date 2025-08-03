class Project < ApplicationRecord
  belongs_to :user

  validates :prompt, presence: true
  validates :homepage_url, allow_nil: true, format: { with: URI.regexp }
end
