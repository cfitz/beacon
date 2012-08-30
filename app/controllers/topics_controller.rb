require 'will_paginate/array'
class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.json
  def index
    # q= Neo4j.query {  query(Person, "'*:*'", :fulltext) -( r =  rel("r:`Person#created_work`") ) - :c; ret n, count(r) }  
    
    query = Neo4j.query {  query(Document, "'*:*'")-( r = rel("r:topics") )-:n; ret(:n, count(r)).desc(count(r)) } 
    @topics = query.to_a.paginate(:page => params[:page], :per_page => 10 )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end
  end


end
