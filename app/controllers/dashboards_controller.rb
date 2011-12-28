class DashboardsController < ApplicationController
  filter_access_to :show,         :attribute_check => true, :load_method => :find_club
  filter_access_to :select_club, :index,  :attribute_check => false
  layout "dashboard"

  def index
    @club = Club.new
    @clubs = Club.alpha.paginate(:page => params[:page], :per_page => 20)
    
    @recent_clubs = Club.recently_created.limit(5)
  end
  
  def select_club
    #raise params.inspect
    redirect_to dashboard_path(params[:club_id])
  end
  
  def show
    
  end
  
  # def goodbye
  #   Club.find(params[:id])
  # end
  
  protected
    def permission_denied
      redirect_to root_url
    end
    
    def find_club
      Club.find(params[:id])
    end
    
  # private
  #  def method_name
  #   
  #  end
end