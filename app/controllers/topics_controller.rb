class TopicsController < ApplicationController
  
  
  # GET /topics
  # GET /topics.json
  def index
#    params[:q].blank? ? @topics = Topic.all.paginate(:page => params[:page], :per_page => 10 ) : @topics = Topic.all("name: #{params[:q].split(" ").first}*", :type => :fulltext).asc(:name).paginate(:page => params[:page], :per_page => 10 )    
    params[:sort] ||= "related_documents:desc"
    @topics = Topic.elastic_search params 
    @facets = @topics.facets
  


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



    # GET /topics/new
    # GET /topics/new.json
    def new
      @topic = Topic.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @topic }
      end
    end

    # GET /topics/1/edit
    def edit
      @topic = Topic.find_sluggable(params[:id])
    end

    # POST /topics
    # POST /topics.json
    def create
      @topic = Topic.new(params[:topic])
      respond_to do |format|
        if @topic.save
          format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
          format.json { render json: @topic, status: :created, location: @topic }
        else
          format.html { render action: "new" }
          format.json { render json: @topic.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /topics/1
    # PUT /topics/1.json
    def update
      @Topic = Topic.find_sluggable(params[:id])

      respond_to do |format|
        if @topic.update_attributes(params[:topic])
          format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @topic.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /topics/1
    # DELETE /topics/1.json
    def destroy
      @topic = Topic.find_sluggable(params[:id])
      @topic.destroy

      respond_to do |format|
        format.html { redirect_to topics_url }
        format.json { head :no_content }
      end
    end


end
  
  


