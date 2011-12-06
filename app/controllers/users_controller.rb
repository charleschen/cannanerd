class UsersController < ApplicationController
  filter_resource_access
  before_filter :quiz_authentication, :only => [:new, :create]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      quiz_session.get_quiz.update_attribute(:user_id, @user.id)
      @user.init_user
      UserSession.create @user    # logs user in automatically
      flash[:notice] = "Registration successful"
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :notice  => "Successfully updated user."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, :notice => "Successfully destroyed user."
  end
  
  private
    def quiz_authentication
      unless quiz_session.submit_quiz?
        flash[:notice] = "Need to take questionnaire before registering"
        redirect_to root_path
      end
    end
end
