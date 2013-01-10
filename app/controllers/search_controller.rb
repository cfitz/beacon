require 'will_paginate/array'

class SearchController < ApplicationController


  def index
     @search = Search.multi_index_search(params)
     @facets = @search.facets ? @search.facets : []
        
     respond_to do |format|
       format.html # { render text: @search.inspect}
       format.xml { render text: @search.inspect }
       format.json { render json: @search.collect { |r| { 'id' => r.id, 'name' => "#{r.name} -- #{r.class}", 'url' => url_for(r)} }.to_json }
     end
   end




end
