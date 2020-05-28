class Product < ApplicationRecord
   belongs_to :user
   has_many :reviews, dependent: :destroy
   has_many :favourites, dependent: :destroy
   has_many :favouriters, through: :favourites, source: :user
   has_many :taggings, dependent: :destroy
   has_many :tags, through: :taggings


  validates(:title, presence: true, uniqueness: true, case_sensitive: false)
  validates(:price, numericality: { greater_than: 0 })
  validates(:description, presence: true, length: { minimum: 10 })
  before_validation :set_default_value_price
  before_save :capitalize_product_title
  # validate: (:set_default_value_price)

  scope(:search, ->(query) { where("title ILIKE ?", "%#{query}%") })

  def tag_names
    self.tags.map{ |t| t.name }.join(",")
  end

  # Appending = at the end of a method name, allows to implement
  # a "setter". A setter is a method that is assignable.
  # Example:
  # p.tag_names = "stuff,yo"
  # The code in the example above would call the method we wrote
  # below where the value on the right-hand side of the = would
  # become the argument to the method.
  # This is similar to implementing an `attr_writer`.
  def tag_names=(rhs)
    self.tags = rhs.strip.split(/\s*,\s*/).map do |tag_name|
      Tag.find_or_initialize_by(name: tag_name)
    end
  end

  private

  def set_default_value_price
    self.price ||= 1
  end

  def capitalize_product_title
    self.title.capitalize!
  end
end
