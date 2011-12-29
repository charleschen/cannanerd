class ClubsController < ApplicationController
  filter_resource_access
  respond_to :html, :json
  
  def new
    @club = Club.new
  end
  
  def create
    @club = Club.new(params[:club])
    @club.password              = ENV["CLUB_DEFAULT_PASSWORD"]
    @club.password_confirmation = ENV["CLUB_DEFAULT_PASSWORD"]
    
    if @club.save
      flash[:notice] = "Club successfully created"
      redirect_to clubs_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    
  end
  
  def update
    @club.update_attributes(params[:club])
    respond_with @club
    
    # if @club.update_attributes(params[:club])
    #   flash[:success] = 'Club info updated'
    #   redirect_to @club
    # else
    #   flash.now[:eror] = 'Club was not updated'
    #   render 'edit'
    # end
  end
  
  def index
    @miles_selection = [['5 miles',5],['10 miles',10],['15 miles',15],['20 miles',20],['25 miles',25]]
    
    if params[:miles]
      @miles_selected = params[:miles]
      puts @miles_selected 
    else
      @miles_selected = [5]
    end
    
    if current_user && current_user.has_role?('admin') == false
      @clubs = Club.near(current_user.zipcode, @miles_selected.first, :order => :distance)
    else
      @clubs = Club.all
    end
    
    
  end
  
  def show
    if current_user
      @distance = @club.distance_from(current_user.zipcode)
    end
    
    @strains = Strain.search(params[:strain_search])
    
    @stock_strains = @club.stock_strains
  end
end