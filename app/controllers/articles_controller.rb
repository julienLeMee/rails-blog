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
    titles = []
    descriptions = []
    url = 'https://www.basketusa.com/'
    html_file = URI.open(url).read
    doc = Nokogiri::HTML(html_file)
    doc.search('section')[0..20].each do |element|
      element.search('h3').each do |title_element|
        titles << title_element.text.strip
      end
      element.search('.meta-desc').each do |description_element|
        descriptions << description_element.text.strip
      end
    end
    titles.each_with_index do |title, index|
      articles << Article.create!(title: title, description: descriptions[index])
    end
        # title = title_element.text.strip
        # element.search('.meta-desc').each do |description_element|
        #   description = description_element.text.strip
        #   articles << Article.create!(title: title, description: description)

    articles.each do |article|
      article.destroy if article.title == 'Toute l’info NBA en continu'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description)
  end
end
