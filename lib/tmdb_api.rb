module TmdbApi
  def self.api_key
    "be82a0d88be700b365b64176607645a3"
  end

  def self.access_token
    "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZTgyYTBkODhiZTcwMGIzNjViNjQxNzY2MDc2NDVhMyIsIm5iZiI6MTc0MDY1MTk3Ny40NjQsInN1YiI6IjY3YzAzZGM5ODM0MDU4ZjE2YWM4ZDdhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SRkoYRfrRHWbJLyIIS-JyzxPi61p-xOkl4oxTXxMLyI"
  end

  def self.base_url
    @base_url ||= fetch_configuration["images"]["base_url"]
  end

  def self.image_size
    @image_size ||= fetch_configuration["images"]["poster_sizes"].find { |size| size == "w500" } || fetch_configuration["images"]["poster_sizes"].first
  end

  def self.fetch_configuration
    return @configuration if @configuration

    require 'open-uri'
    require 'json'

    config_url = "https://api.themoviedb.org/3/configuration?api_key=#{api_key}"
    config_serialized = URI.open(config_url).read
    @configuration = JSON.parse(config_serialized)
  end

  def self.poster_url(poster_path)
    "#{base_url}#{image_size}#{poster_path}"
  end

  def self.fetch_movies
    require 'open-uri'
    require 'json'

    url = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=vote_average.desc&without_genres=99,10755&vote_count.gte=200&api_key=#{api_key}"
    movies_serialized = URI.open(url).read
    JSON.parse(movies_serialized)
  end
end 