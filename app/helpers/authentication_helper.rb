module AuthenticationHelper
  
  protected
  

   def enforce_permissions
     unless current_user && current_user.admin?
         redirect_to("/", :notice => "You currently do not have permissions to view this section. If this is an error, please contact the system administrator.")
     end
   end
  
  
  
   def enforce_logged_in
     unless current_user
         redirect_to("/", :notice => "You currently do not have permissions to view this section. If this is an error, please contact the system administrator.")
     end
   end
  
end