class Project < ApplicationRecord
  belongs_to :user

  validates :prompt, presence: true
  validates :homepage_url, allow_blank: true, format: { with: URI.regexp }
  # TODO: allow_blank => allow_nil
end
