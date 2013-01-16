class UsersController < ApplicationController
   include AuthenticationHelper

  before_filter :enforce_permissions, :only => [:index, :destroy,  ]
  before_filter :enforce_is_admin_or_is_current_user, :only => [:edit, :show, :update]
  
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
     @user = User.find(params[:id])
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
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