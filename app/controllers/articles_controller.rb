require 'open-uri'
require 'nokogiri'

class ArticlesController < ApplicationController
  def index
    scrape
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.save
  end

  def scrape
    Article.destroy_all if Rails.env.development?
    articles = []
    url = 'https://www.basketusa.com/'
    html_file = URI.open(url).read
    doc = Nokogiri::HTML(html_file)
    doc.search('section')[0..20].each do |element|
      element.search('h3').each do |title_element|
        title = title_element.text.strip
        description = element.search('.meta-desc').text.strip
        articles << Article.create!(title: title, description: description)
      end
    end

    articles.each do |article|
      article.destroy if article.title == 'Toute l’info NBA en continu'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description)
  end
end
