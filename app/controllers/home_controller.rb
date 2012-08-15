require 'lib/graphz'

class HomeController < ApplicationController
  
  def index
    @graph = Graphz.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render @graph.to_xml }
    end
  end



end
