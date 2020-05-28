FactoryBot.define do
  factory :news_article do
    sequence(:title) { |n| Faker::Quote.most_interesting_man_in_the_world + " #{n}" }
    description { Faker::Hacker.say_something_smart }
    user
  end
end
