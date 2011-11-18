class LikesController < ApplicationController
  filter_access_to :create, :destroy
  
  def create
    @target = Likeable.find_by_resource_id(params[:resource_name], params[:resource_id])
    current_user.like!(@target)
    puts 'liking!'
    respond_to do |format|
      format.html {redirect_to :back}
      format.js 
    end
  end
  
  def destroy
    @target = Likeable.find_by_resource_id(params[:resource_name],params[:resource_id])
    current_user.unlike!(@target)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end
  
  
end