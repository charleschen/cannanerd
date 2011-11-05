require 'authlogic'

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  helper_method :current_user, :current_club
  
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_club_session
    return @current_club_session if defined?(@current_club_session)
    @current_club_session = ClubSession.find
  end
  
  def current_club
    return @current_club if defined?(@current_club)
    @current_club = current_club_session && current_club_session.record
  end

end
