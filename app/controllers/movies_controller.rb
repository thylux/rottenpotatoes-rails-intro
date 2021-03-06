class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    order = params.has_key?(:sort) ? params[:sort] : session[:sort]
    
    if(order)
      @movies = get_movies_filtered_by_rating.order(order)
    else
      @movies = get_movies_filtered_by_rating
    end
    session[:sort] = order
    @all_ratings=Movie.get_all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  private
  def get_movies_filtered_by_rating
    ratings = params.has_key?(:ratings) ? params[:ratings] : session[:ratings]
    session[:ratings] = ratings
    if(ratings && ratings.length > 0)
      Movie.where({ rating: ratings.keys})
    else
      Movie.all
    end
  end

end
