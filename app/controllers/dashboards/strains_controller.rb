class Dashboards::StrainsController < ApplicationController
  #filter_access_to :all, :attribute_check => true, :load_method => :find_club
  
  layout "dashboard"
  
  def index
    @strains = Club.find(params[:id]).strains.paginate(:page => params[:page], :per_page => 6)
  end
  
  def update
    #raise params.inspect
    @strain = Strain.find(params[:id])
    if @strain.update_attributes(params[:strain])
      flash[:success] = 'Updated strain!'
      redirect_to :back
    else
      flash.now[:error] = 'Could not update strain'
      render 'index', :page => params[:page]
    end
  end
  
  protected
    def permission_denied
      redirect_to root_url
    end
    
    def find_club
      Club.find(params[:id])
    end
end