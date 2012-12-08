require 'will_paginate/array'

class SearchController < ApplicationController


  def index
     default_indexes = ['documents', 'people', 'topics', 'places' ]
     if !params[:q].blank?
       
       
       
       search_term = params[:q]
       params[:type] ? indexes = params[:type] : default_indexes
       params[:page] ? page = params[:page].to_i : page = 1
       
       offset = ( ( page - 1) * 10)
       search = Tire.search indexes, :load => false, :from => offset do 
          query do
            boolean do
              should { match :name, "#{search_term}*", :type => :phrase_prefix }
              should { match :content, search_term, :type => :phrase}
            end
          end
          facet "item_type" do terms :_type end
          highlight :content, :title
          sort { by "_score"}
          
       end 
     
       @search = search.results       
       @search.results.collect! { |es_result| result = es_result.load; result.highlight = es_result.highlight if result.respond_to?(:highlight); result }
       @facets = @search.facets
            
    else
      @search = []
    end
     
     respond_to do |format|
       format.html # { render text: @search.inspect}
       format.xml { render text: @search.inspect }
       format.json { render json: @search.collect { |r| { 'id' => r.id, 'name' => "#{r.name} -- #{r.class}", 'url' => url_for(r)} }.to_json }
     end
   end




end
