# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Article.destroy_all if Rails.env.development?

# require 'open-uri'
# require 'nokogiri'

# def scrape
#   articles = []
#   url = 'https://www.basketusa.com/'
#   html_file = URI.open(url).read
#   doc = Nokogiri::HTML(html_file)
#   doc.search('section')[0..20].each do |element|
#     element.search('h3').each do |title_element|
#       title = title_element.text.strip
#       description = element.search('.meta-desc').text.strip
#       articles << Article.create!(title: title, description: description)
#     end
#   end

#   articles.each do |article|
#     p article.description
#     article.destroy if article.title == 'Toute l’info NBA en continu'
#   end
# end

# scrape

# require 'faker'

# 12.times do
#   Article.create!(
#     title: Faker::TvShows::BreakingBad.episode,
#     description: Faker::JapaneseMedia::OnePiece.quote
#   )
# end

# def scrape
#   Article.destroy_all if Rails.env.development?
#   articles = []
#   url = 'https://www.basketusa.com/'
#   html_file = URI.open(url).read
#   doc = Nokogiri::HTML(html_file)
#   title = doc.search('section')[0..20].each do |element|
#       element.search('h3').each do |title_element|
#         title_element.text.strip
#       end
#     end
#   description = doc.search('section')[0..20].each do |element|
#       element.search('.meta-desc').each do |description_element|
#         description_element.text.strip
#       end
#     end
#   articles << Article.create!(title: title, description: description)

#   articles.each_with_index do |article, index|
#     article.destroy if article.title == 'Toute l’info NBA en continu'
#     p "#{index + 1} - #{article.title}"
#     p "#{index + 1} - #{article.description}"
#   end
# end

# scrape
