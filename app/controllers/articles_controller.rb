class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    session_count = session[:page_views] ||= 0
    session_count= session[:page_views] += 1
    
    if session_count < 3 
      render json: article
    elsif
      render json: {error: "Maximum pageview limit reached"} , status: :unauthorized
    end
  
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
