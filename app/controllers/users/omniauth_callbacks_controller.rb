class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
  	    # You need to implement the method below in your model (e.g. app/models/user.rb)
  	    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
  	    if @user.persisted? && @user.approved?
  	      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
  	      sign_in_and_redirect @user, :event => :authentication
  	    # in theory, we probably want to eventually redirect users to a login to allow them to add their data?
  	    else # elsif @user.persisted? && !@user.approved?
  	      sign_out(@user)
  	      flash[:notice] = I18n.t "devise.failure.not_approved"
  	      redirect_to "/"
  	    # else
  	    #  session["devise.google_data"] = request.env["omniauth.auth"]
  	    #  redirect_to new_user_registration_url
  	    end
  	end
end