# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'
require 'json'

puts "Cleaning database..."
Bookmark.destroy_all
Movie.destroy_all
List.destroy_all

puts "Creating movies..."

# Remplacez ACCESS_TOKEN par votre véritable token d'API TMDb
# My API key: b882a0d8be700b365b64176607645a3
# My API read access token: eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZTgyYTBkODhiZTcwMGIzNjViNjQxNzY2MDc2NDVhMyIsIm5iZiI6MTc0MDY1MTk3Ny40NjQsInN1YiI6IjY3YzAzZGM5ODM0MDU4ZjE2YWM4ZDdhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SRkoYRfrRHWbJLyIIS-JyzxPi61p-xOkl4oxTXxMLyI

url = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=vote_average.desc&without_genres=99,10755&vote_count.gte=200"
authorization = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZTgyYTBkODhiZTcwMGIzNjViNjQxNzY2MDc2NDVhMyIsIm5iZiI6MTc0MDY1MTk3Ny40NjQsInN1YiI6IjY3YzAzZGM5ODM0MDU4ZjE2YWM4ZDdhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SRkoYRfrRHWbJLyIIS-JyzxPi61p-xOkl4oxTXxMLyI"

movies_serialized = URI.open(url, "Authorization" => authorization).read
movies = JSON.parse(movies_serialized)

movies["results"].each do |movie_data|
  Movie.create!(
    title: movie_data["title"],
    overview: movie_data["overview"],
    poster_url: "https://image.tmdb.org/t/p/original#{movie_data["poster_path"]}",
    rating: movie_data["vote_average"]
  )
  puts "Created #{movie_data["title"]}"
end

puts "Creating lists..."
["Action", "Comedy", "Drama", "Classic", "Horror"].each do |name|
  list = List.create!(name: name)
  puts "Created #{name} list"
end

puts "Finished!"
