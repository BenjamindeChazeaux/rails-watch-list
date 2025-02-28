require 'open-uri'
require 'tmdb_api'

class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    @base_url = TmdbApi.base_url
    @image_size = TmdbApi.image_size
    @lists = List.all
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def show_json
    @movie = Movie.find(params[:id])
    render json: @movie
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

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :poster_url, :rating)
  end
end 