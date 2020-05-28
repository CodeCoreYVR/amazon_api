require 'rails_helper'

RSpec.describe NewsArticle, type: :model do
  def news_article
    @news_article ||= NewsArticle.new(
      title: 'Awesome Article',
      description: 'This is just the best article.'
    )
  end

  describe 'validations' do
    it "has a title" do
      n = news_article
      n.title = nil
      n.valid?
      expect(n.errors).to have_key(:title)
    end

    it "has a unique title" do
      n = news_article
      n.save
      n2 = NewsArticle.new(title: 'Awesome Article', description: "Test")
      n2.valid?
      expect(n2.errors).to have_key(:title)
    end

    it "has a description" do
      n = news_article
      n.description = nil
      n.valid?
      expect(n.errors).to have_key(:description)
    end

    it "ensures the published_at date is after the created_at date" do
      n = news_article
      n.save
      n.published_at = n.created_at
      n.valid?
      expect(n.errors).to have_key(:published_at)
    end
  end

  describe '#titleized_title' do
    it 'titleizes the title' do
      n = news_article
      n.title = "another cool article"
      titleized_title = n.titleized_title
      expect(titleized_title).to eq("Another Cool Article")
    end

    it 'it properly updates the title in a callback' do
      n = news_article
      n.title = "another cool article"
      n.save
      expect(NewsArticle.last.title).to eq("Another Cool Article")
    end
  end

  describe '#publish' do
    it 'sets published_at to the current_date' do
      n = news_article
      n.save
      n.publish
      expect(n.published_at.to_i).to eq(Time.zone.now.to_i)
      # the Time.zone.now call when we call n.publish and the Time.zone.now call
      # in our expect statement will likely differ by fractional seconds. If we
      # don't care about those microsecond differences we can just call .to_i or
      # .to_s on them to ensure that this isn't what causes our test to fail.
    end
  end

  describe '.published' do
    it 'returns the published articles' do
      n1 = NewsArticle.create(title: 'article 1', description: "Test")
      n2 = NewsArticle.create(title: 'article 2', description: "Test")
      n3 = NewsArticle.create(title: 'article 2', description: "Test")
      n1.publish
      n2.publish
      expect([n1, n2]).to eq(NewsArticle.published)
    end
  end
end
