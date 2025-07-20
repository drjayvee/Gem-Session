class Project < ApplicationRecord
  validates :prompt, presence: true
  validates :homepage_url, allow_blank: true, format: { with: URI.regexp }
end
