class NewsArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :find_news_article, only: [:show, :edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update]

  def index
    @news_articles = NewsArticle.order(created_at: :DESC)
  end

  def show
  end

  def new
   @news_article = NewsArticle.new
  end

 def create
    @news_article = NewsArticle.new news_article_params
    @news_article.user = current_user
    if @news_article.save
      flash[:notice] = 'Article created!'
      redirect_to @news_article
    else
      render :new
    end
 end

 def edit
 end

 def update
   if @news_article.update news_article_params
    flash[:notice] = 'Article updated!'
    redirect_to @news_article
   else
    flash[:alert] = 'Something went wrong, see errors below.'
    render :edit
   end
 end

 def destroy
   @news_article.destroy
   flash[:alert] = 'Article deleted!'
   redirect_to news_articles_path
 end

 private

 def news_article_params
   params.require(:news_article).permit(:title, :description)
 end

 def find_news_article
   @news_article = NewsArticle.find params[:id]
 end

 def authorize!
  redirect_to root_path, alert: "access denied" unless can? :crud, @news_article
 end
end
