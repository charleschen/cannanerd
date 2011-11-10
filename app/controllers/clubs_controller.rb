class ClubsController < ApplicationController
  filter_resource_access
  
  def new
    @club = Club.new
  end
  
  def create
    @club = Club.new(params[:club])
    @club.password              = ENV["CLUB_DEFAULT_PASSWORD"]
    @club.password_confirmation = ENV["CLUB_DEFAULT_PASSWORD"]
    
    if @club.save
      flash[:notice] = "Club successfully created #{ENV["CLUB_DEFAULT_PASSWORD"]}"
      redirect_to clubs_path
    else
      render :action => 'new'
    end
  end
  
  def index
  end
  
  def show
    
  end
end