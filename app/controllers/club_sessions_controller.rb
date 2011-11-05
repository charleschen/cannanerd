class ClubSessionsController < ApplicationController
  def new
    @club_session = ClubSession.new
  end
  
  def create
    @club_session = ClubSession.new(params[:club_session])
    if @club_session.save
      flash[:notice] = "Club logged in!"
      redirect_to root_url
    else
      flash[:error] = "Wrong password"
      render :action => 'new'
    end
  end
  
  def destroy
    @club_session = ClubSession.find(params[:id])
    @club_session.destroy
    flash[:notice] = 'Logged out!'
    redirect_to root_url
  end
end