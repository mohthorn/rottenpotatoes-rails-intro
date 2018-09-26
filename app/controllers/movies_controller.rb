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
       
    @all_ratings = Movie.get_ratings
    
    @filtered_ratings = params[:ratings]
    print("filter is")
    print( @filtered_ratings)
    if(@filtered_ratings.nil?)
      print("yes")
      @movies = Movie.all
    else
      @movies = Movie.where(rating:[@filtered_ratings.keys])
    end
    
    if params[:sorting_param]=='title'
      @movies = @movies.sort { |a,b| a.title <=> b.title }
      @title_highlight = "hilite"
    else if params[:sorting_param]=='release_date'
        @movies = @movies.sort { |a,b| a.release_date<=>b.release_date}
        @date_highlight = "hilite"
      end
    end
    
    
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

end
