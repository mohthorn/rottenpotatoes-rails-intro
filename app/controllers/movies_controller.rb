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
    
    unless params[:ratings].nil?
      @filtered_ratings = params[:ratings]
      session[:filtered_ratings] = @filtered_ratings
    end
    
    unless(params[:sorting_param].nil?)
      session[:sorting_param]=params[:sorting_param]
    end
    
    #to be RESTful
    if params[:sorting_param].nil? && params[:ratings].nil? && session[:filtered_ratings] #should
      @filtered_ratings = session[:filtered_ratings]
      @sorting_param = session[:sorting_param]
      flash.keep
      redirect_to movies_path({order_by: @sorting_param, ratings: @filtered_ratings})
    else
      if session[:filtered_ratings].nil?    
        params[:sorting_param]={"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"}
      end
    end
    
    
    if(session[:filtered_ratings].nil?)
      @movies = Movie.all
    else
      @movies = Movie.where(rating:[session[:filtered_ratings].keys])
    end
    
    
    if session[:sorting_param]=='title'
      @movies = @movies.sort { |a,b| a.title <=> b.title }
      @title_highlight = "hilite"
    else if session[:sorting_param]=='release_date'
        @movies = @movies.sort { |a,b| a.release_date<=>b.release_date}
        @date_highlight = "hilite"
      end
    end
    #session.delete(:sorting_param)
    #session.delete(:filtered_ratings)
    
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
