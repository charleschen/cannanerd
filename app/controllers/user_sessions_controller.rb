class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if current_club
        ClubSession.find.destroy
      end
      flash[:notice] = "Logged in!"
      redirect_to root_url
    else
      flash[:error] = "Wrong password"
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find(params[:id])
    @user_session.destroy
    flash[:notice] = 'Logged out!'
    redirect_to root_url
  end
end
