class Dashboards::ClubsController < ApplicationController
  filter_access_to :update, :attribute_check => true, :load_method => :find_club
  filter_access_to :create, :attribute_check => false
  
  def create
    @clubs = Club.all
    @club = Club.new(params[:club])
    
    @club.password              = ENV["CLUB_DEFAULT_PASSWORD"]
    @club.password_confirmation = ENV["CLUB_DEFAULT_PASSWORD"]
    
    if @club.save
      flash[:sucess] = "club created"
      redirect_to dashboard_path(@club.id)
    else
      flash.now[:error] = 'Could not create'
      render 'dashboards/index', :layout => "dashboard"
    end
  end
  
  def update
    respond_to do |format|
      if @club.update_attributes(params[:club])
        format.json { respond_with_bip(@club) }
      else
        format.json { respond_with_bip(@club) }
      end
    end
  end
  
  protected
    def permission_denied
      redirect_to root_url
    end
    
    def find_club
      @club = Club.find(params[:id])
    end
end