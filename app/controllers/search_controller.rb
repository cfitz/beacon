class SearchController < ApplicationController


  def index
    
     if !params[:search].blank?
       term = params[:search]
       params[:page] ? page = params[:page].to_i : page = 1
       
       offset = ( ( page - 1) * 10)
       search = Tire.search ['documents', 'people', 'concepts',  'places', 'things' ], :load => true, :from => offset do 
          query { string "#{term}*" }
          sort { by "_score"}
       end 
     
       @search = search.results
     
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
