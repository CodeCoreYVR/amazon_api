class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, uniqueness: {
    scope: :review_id,
    message: "has already been voted on"
  }
  validates :is_up, inclusion: {
    in: [true, false]
  }

  def self.up
    where(is_up: true)
  end

  def self.down
    where(is_up: false)
  end
end
