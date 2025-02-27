class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    fetch_tmdb_configuration
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: 'Movie was successfully created.'
    else
      render :new
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_url, notice: 'Movie was successfully destroyed.'
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :poster_url, :rating)
  end

  def fetch_tmdb_configuration
    config_url = "https://api.themoviedb.org/3/configuration?api_key=YOUR_API_KEY"
    config_serialized = URI.open(config_url).read
    config = JSON.parse(config_serialized)

    # Extract base URL and image size
    @base_url = config["images"]["base_url"]
    @image_size = config["images"]["poster_sizes"].find { |size| size == "w500" } || config["images"]["poster_sizes"].first
  end
end 