class LikesController < ApplicationController
  filter_access_to :create, :destroy
  
  def create
    klass = params[:resource_name].camelcase.constantize
    @target = klass.find(params[:resource_id])
    current_user.like!(@target)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js 
    end
  end
  
  def destroy
    klass = params[:resource_name].camelcase.constantize
    @target = klass.find(params[:resource_id]) 
    current_user.unlike!(@target)
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end
  
  
end