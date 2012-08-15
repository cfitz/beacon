# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    params["approved"] ||= false
    params["admin"] ||= false
    super
  end

  def update
    super
  end
end 