class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.json
  
  def index
    
    params[:q].blank? ? @topics = Topic.all.paginate(:page => params[:page], :per_page => 10 ) : @topics = Topic.all("name: #{params[:q].split(" ").first}*", :type => :fulltext).asc(:name).paginate(:page => params[:page], :per_page => 10 )
    
      
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end







  # GET /people/1
  # GET /people/1.json
  def show
    @topic = Topic.find_sluggable(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end



end
