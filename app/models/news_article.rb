class NewsArticle < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validate :published_after_create

  before_validation :titleized_title

  def publish
    update(published_at: Time.zone.now)
  end

  def titleized_title
    self.title = self.title&.titleize
  end

  scope :published, -> { where( 'published_at > created_at' ) }
  # Same as
  # def self.published
  #   where( 'published_at > created_at' )
  # end

  private

  def published_after_create
    return unless published_at.present?
    errors.add(:published_at, "You cannot immediately publish this article") if published_at <= created_at
  end
end
