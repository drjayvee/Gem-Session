class Project < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :rubygems

  validate :validate_rubygems
  validates :prompt, presence: true
  validates :homepage_url, allow_nil: true, format: { with: URI.regexp }

  scope :published, -> { where.not(homepage_url: nil) }

  def published?
    homepage_url.present?
  end

  def visible_to?(user = nil)
    published? or self.user.id == user&.id
  end

  private

    def validate_rubygems
      errors.add(:rubygems, "must have exactly two, not #{rubygems.size}") unless rubygems.size == 2
      errors.add(:rubygems, "must not contain duplicates") unless rubygems.uniq.size == rubygems.size
    end
end
