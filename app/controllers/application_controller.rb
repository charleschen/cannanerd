require 'authlogic'

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  helper_method :current_user, :current_club, :quiz_session, :any_user?
  
  before_filter { |c| Authorization.current_user = current_user }

  
  protected  
    def permission_denied
      flash[:error] = "Sorry, you do not have access for this page"
      redirect_to root_url
    end
  
  private
    def quiz_session
      @quiz_session ||= QuizSession.new(session)
    end
    
    def any_user?
      !current_user.nil? || !current_club.nil?
    end
    
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
