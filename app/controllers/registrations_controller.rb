# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  include AuthenticationHelper
  before_filter :enforce_permissions, :only => [:update]
  
  def new
    super
  end

  def create
    params[:user][:admin], params[:user][:approved] = false, false unless is_admin?
    super
  end

  def update
    super
  end
  

end 