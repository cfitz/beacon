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
  
  def enforce_aws_permissions( url )
    if @item.public? #if it is public, generate redirect to aws
      aws_redirect( url)
    elsif current_user # if user is logged in, generate redirect to aws
      aws_redirect( url)
    else
       render :file => "public/401.html", :status => :unauthorized and return
    end
  end
  
  
  private
  
  def aws_redirect( url, options= {})
        options.reverse_merge! :expires_in => 10.minutes, :use_ssl => true
        url.gsub!(url.split("?").last, "").delete!("?") if url.include?("?") # paperclip adds a query string, which we need to delete. 
        url.gsub!("https://s3.amazonaws.com/wmu-library/", "") # AWS::S3 Adds this. We don't want it twice.         
        aws_url = AWS::S3::S3Object.url_for url, @item.attachment.options[:bucket], options
        redirect_to( aws_url ) and return
  end
  
end