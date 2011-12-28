class Dashboards::ClubsController < ApplicationController
  def create
    #raise params.inspect
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
end