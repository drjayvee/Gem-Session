class Rubygem < ApplicationRecord
  has_and_belongs_to_many :projects

  validates :name, :description, :homepage_url, presence: true, allow_nil: false
  validates :name, uniqueness: true
  validates :homepage_url, format: { with: URI.regexp }
end
