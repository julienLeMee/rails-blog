require 'open-uri'
require 'nokogiri'

class ArticlesController < ApplicationController
  def index
    scrape
    # scrape_each_article
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    # scrape_each_article
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
    titles.each_with_index do |title, index|
      articles << Article.create!(title: title, description: descriptions[index], image: images[index])
    end

    articles.each do |article|
      article.destroy if article.title == 'Toute l’info NBA en continu'
    end
  end

  # def scrape_each_article
  #   url = 'https://www.basketusa.com/'
  #   html_file = URI.open(url).read
  #   doc = Nokogiri::HTML(html_file)
  #   doc.search('.list-news').each do |element|
  #     element.search('a').each do |link|
  #       @article.url = link.attribute('href').value
  #     end
  #   end
  # end

  private

  def article_params
    params.require(:article).permit(:title, :description, :image, :url)
  end
end
