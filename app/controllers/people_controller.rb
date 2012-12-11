class PeopleController < ApplicationController
  # GET /people
  # GET /people.json
  def index
    
   # params[:q].blank? ? @people = Person.all.paginate(:page => params[:page], :per_page => 10 ) : @people = Person.all("name: #{params[:q].split(" ").first}*", :type => :fulltext).asc(:name).paginate(:page => params[:page], :per_page => 10 )
   params[:sort] ||= "name_sort:asc"
   
   @people = Person.elastic_search params 
   @facets = @people.facets
      
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find_sluggable(params[:id])
     unless @person
       begin
         @person = Person.find(params[:id])
       rescue Java::JavaLang::RuntimeException
         @person = nil
       end
     end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    @person = Person.new

    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find_sluggable(params[:id])
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render json: @person, status: :created, location: @person }
        format.js  { render json: @person, status: :created, location: @person }
      else
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
        format.js  { render json: @person, status: :created, location: @person, content_type: 'text/json'  }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find_sluggable(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find_sluggable(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end
end
