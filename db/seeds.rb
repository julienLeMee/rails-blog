# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Article.destroy_all if Rails.env.development?

require 'open-uri'
require 'nokogiri'

# require 'faker'

# 12.times do
#   Article.create!(
#     title: Faker::TvShows::BreakingBad.episode,
#     description: Faker::JapaneseMedia::OnePiece.quote
#   )
# end

def scrape
  articles = []
  url = 'https://www.basketusa.com/'
  html_file = URI.open(url).read
  doc = Nokogiri::HTML(html_file)
  doc.search('.list-news').each do |element|
    title = element.search('h3').first.text.strip
    description = element.search('.meta-desc').text.strip
    articles << Article.create!(title: title, description: description)
  end
end

scrape
