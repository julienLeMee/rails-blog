require 'open-uri'
require 'nokogiri'

class ArticlesController < ApplicationController
  def index
    scrape
    if params[:query].present?
      sql_query = "title ILIKE :query OR synopsis ILIKE :query"
      @articles = Article.where(sql_query, query: "%#{params[:query]}%")
      @articles = Article.where(url: params[:query])
    else
      @articles = Article.all
    end
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
    images = []
    urls = []
    url = 'https://www.basketusa.com/'
    html_file = URI.open(url).read
    doc = Nokogiri::HTML(html_file)
    doc.search('section.box').each do |element|
      element.search('.title').each do |title_element|
        titles << title_element.text.strip
      end
      # element.search('.meta-desc').each do |description_element|
      #   descriptions << description_element.text.strip
      # end

      element.search('img').each do |image_element|
        images << image_element.attribute('data-src').value
      end
      # element.search('a').each do |link|
      #   article_url = link.attribute('href').value
      #   article_html_file = URI.open(article_url).read
      #   article_doc = Nokogiri::HTML(article_html_file)
      #   article_doc.search('p').each do |description_element|
      #     descriptions << description_element.text.strip
      #   end
      # end
    end

    doc.search('feed-news').each do |link|
      urls << link.attribute('href').value if link.attribute('href').value.include?('https://www.basketusa.com/news/')
    end

    titles.each_with_index do |title, index|
      articles << Article.create!(title: title, description: descriptions[index], image: images[index], url: urls[index])
    end

    articles.each do |article|
      article.destroy if article.title == 'Toute l’info NBA en continu'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :image, :url)
  end
end
