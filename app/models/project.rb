class Project < ApplicationRecord
  validates :prompt, presence: true
  validates :repo_url, allow_blank: true, format: { with: URI.regexp }
end
