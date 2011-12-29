class Dashboards::StrainsController < ApplicationController
  filter_access_to :all, :attribute_check => true, :load_method => :find_club
  layout "dashboard"
  
  def create
    #@club = Club.find(params[:id])
    @new_strain = @club.strains.new(params[:strain])
    @strains = @club.strains.paginate(:page => params[:page], :per_page => 6)
    
    if @new_strain.save
      redirect_to :back
    else
      render 'index', :page => params[:page]
    end
  end
  
  def index
    #@club = Club.find(params[:id])
    
    @strains = @club.strains.recently_created.paginate(:page => params[:page], :per_page => 6)
    @new_strain = @club.strains.new
  end
  
  def update
    @strain = Strain.find(params[:id])
    
    respond_to do |format|
      if @strain.update_attributes(params[:strain])
        format.json { respond_with_bip(@strain) }
        format.html { redirect_to :back }
      else
        format.json { respond_with_bip(@strain)}
        format.html { render 'index', :page => params[:page] }
      end
    end
  end
  
  def destroy
    @strain = Strain.find(params[:id])
    @strain.destroy
    redirect_to :back
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