module AuthenticationHelper
  
  protected
  
    # this enforces admin permissions
   def enforce_permissions
     bounce unless is_admin?
   end
  
  # this enforces that the user is either an admin or the current user specificed in the params[:id]
  def enforce_is_admin_or_is_current_user
    bounce unless is_admin? or is_current_user?
  end
      
   # this enfoces that a user is logged in. 
   def enforce_logged_in
    bounce unless current_user
   end
   
   # convenince to check if it's an admin
   def is_admin?
     current_user && current_user.admin?
   end
   
   # only admins or the current user can edit certain pages. 
   def is_current_user?
     current_user && current_user.id == params[:id]
   end
   
   # default bounce to the homepage.
   def bounce(notice = "You currently do not have permissions to view this section. If this is an error, please contact the system administrator.")
     redirect_to("/", :notice => notice )
   end
  
  
  
end