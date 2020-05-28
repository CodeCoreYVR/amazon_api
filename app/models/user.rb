class User < ApplicationRecord
  has_many :news_articles, dependent: :nullify
  has_many :products, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_many :liked_reviews, through: :likes, source: :review
  has_many :favourites, dependent: :destroy
  has_many :favourited_products, through: :favourites, source: :product
  has_many :votes, dependent: :destroy
  has_many :voted_reviews, through: :votes, source: :review

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX
  validates :first_name, :last_name, presence: true

  def full_name
   "#{first_name} #{last_name}".strip.titleize
  end
end
