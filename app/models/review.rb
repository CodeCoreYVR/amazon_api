class Review < ApplicationRecord
  # This file was generated (including the `belongs_to :product`) by running
  # following command in the command-line:
  # > rails g model review rating:integer body:text product:references
  belongs_to :user
  belongs_to :product
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user


  validates :rating, {
    numericality: {
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }
  }

  def vote_total
    votes.up.count - votes.down.count
  end
end
