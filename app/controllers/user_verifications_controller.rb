class UserVerificationsController < ApplicationController
  before_filter :load_user_using_perishable_token

  def show
    unless @user.has_role?('member')
      @user.verify!
      @user.check_and_send_top_strains
      flash[:notice] = 'Thank you for verifying your account'
    else
      flash[:notice] = "User already verified!"
    end
    
    redirect_to root_url
  end

  private
  
  def load_user_using_perishable_token
    @user = User.find_by_perishable_token(params[:id])
    flash[:notice] = "Unable to find your account." unless @user
  end
end
