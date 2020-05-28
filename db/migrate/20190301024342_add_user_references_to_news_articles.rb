class AddUserReferencesToNewsArticles < ActiveRecord::Migration[5.2]
  # run -> rails g migration add_user_references_to_news_articles user:references
  def change
    add_reference :news_articles, :user, foreign_key: true
  end
end
