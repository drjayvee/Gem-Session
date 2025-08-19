class Rubygem < ApplicationRecord
  validates :name, :description, :homepage_url, presence: true, allow_nil: false
  validates :name, uniqueness: true
  validates :homepage_url, format: { with: URI.regexp }
end
