# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'tmdb_api'

puts "Cleaning database..."
Bookmark.destroy_all
Movie.destroy_all
List.destroy_all

puts "Creating movies..."

puts "Base URL: #{TmdbApi.base_url}"
puts "Image Size: #{TmdbApi.image_size}"

movies = TmdbApi.fetch_movies

movies["results"].each do |movie_data|
  Movie.create!(
    title: movie_data["title"],
    overview: movie_data["overview"],
    poster_url: TmdbApi.poster_url(movie_data["poster_path"]),
    rating: movie_data["vote_average"]
  )
  puts "Created #{movie_data["title"]} with poster: #{TmdbApi.poster_url(movie_data["poster_path"])}"
end

puts "Creating lists..."
List.destroy_all # Assurez-vous de nettoyer les anciennes listes

# Créez les nouvelles listes avec les noms souhaités
lists = ["À voir absolument", "Mes classiques", "Feel good movies"]

lists.each do |name|
  List.create!(name: name)
  puts "Created #{name} list"
end

puts "Finished!"
