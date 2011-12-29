class Dashboards::ClubsController < ApplicationController
  filter_access_to :all, :attribute_check => true, :load_method => :find_club
  layout "dashboard"
  
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
    @club = Club.find(params[:id])
    
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
      @club = Club.find(club_id_param)
    end
    
    def club_id_param
      request.env['PATH_INFO'][/dashboards\/([0-9]+)/,1]
    end
end