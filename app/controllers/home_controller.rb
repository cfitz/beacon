
class HomeController < ApplicationController
  
  def index
    respond_to do |format|
      format.html # new.html.erb
      format.xml # we will add graph support later
    end
  end



end
