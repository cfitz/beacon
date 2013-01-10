class DocumentsController < ApplicationController
  
  include AuthenticationHelper
  before_filter :enforce_logged_in, :except => [:show, :index]
  
  # GET /documents
  # GET /documents.json
  def index
 #   params[:sort] ||= "name_sort:asc"
    @documents = Document.elastic_search params 
    @facets = @documents.facets
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    
    @document = Document.find_sluggable(params[:id])
    unless @document
      begin
        @document = Document.find(params[:id])
      rescue Java::JavaLang::RuntimeException
        @document = nil
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { document_access_control }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find_sluggable(params[:id])
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(params[:document])
    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find_sluggable(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find_sluggable(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
  
=begin  
  Currently not implimented, but might use? 
  def show_creator_relation
    @document = Document.find_sluggable(params[:document_id])
    @creator = @document.creators.find(params[:person_id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end   
  end
  
  def delete_creator_relation
    @document = Document.find_sluggable(params[:document_id])
    @person = Person.find_sluggable(params[:person_id])
    respond_to do |format|
      if @document.creators.delete(@person)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
      else
        format.html { "NOT OK" }
      end
    end
  end
=end
  
 
  
  
end
