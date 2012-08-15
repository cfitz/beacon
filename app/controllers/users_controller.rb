class UsersController < ApplicationController
   include AuthenticationHelper

  before_filter :enforce_permissions
  
  def show
     @user = User.find(params[:id])
   end



  def index
    if params[:approved] == "false"
      @users = User.find_all_by_approved(false)  
    else 
        @users = User.all
    end
  end
  
  def edit
     @user = User.find_by_id(params[:id])
     @koha_user_data = @user.koha_data
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
          flash[:notice] = "Successfully updated User."
          redirect_to root_path
     else
          flash[:notice] = "Problem updating user" 
          render :action => 'edit'
     end
  end
  
  
 
  
end