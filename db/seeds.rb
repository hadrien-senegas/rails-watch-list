# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
print "Cleaning database..."
Movie.destroy_all
List.destroy_all
Bookmark.destroy_all
puts "Database cleaned!"

require "open-uri"
require "json"

print "Creating movies..."
url = "https://tmdb.lewagon.com/movie/top_rated"
user_serialized = URI.open(url).read
movies = JSON.parse(user_serialized)["results"]
  movies.first(10).each do |movie|
  Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500/#{movie['poster_path']}",
    rating: movie["vote_average"]
  )
end

print "Creating movies done!"
print "Creating lists..."

# Create some lists
List.create!(name: "Action Movies")
List.create!(name: "Romantic Movies")
List.create!(name: "Comedy Movies")

print "Creating lists done!"
print "Creating bookmarks..."

# Create some bookmarks
10.times do
  Bookmark.create(comment: "good movie", list: List.all.sample, movie: Movie.all.sample)
end

print "Seed Done!!"
