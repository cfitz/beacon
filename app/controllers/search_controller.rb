class SearchController < ApplicationController


  def index
    
     if !params[:search].blank?
       term = params[:search]
       params[:page] ? page = params[:page].to_i : page = 1
       
       offset = ( ( page - 1) * 10)
       search = Tire.search ['documents', 'people', 'concepts',  'places', 'things' ], :from => offset do 
          query do
            boolean do
              must { text :_all, "#{term}*", :type => :phrase_prefix }
              should { match :content, term, :type => :phrase}
            end
          end
          highlight :content, :title
          sort { by "_score"}
          
       end 
     
       @search = search.results
       @search.results.collect! { |es_result| result = es_result.load; result.highlight = es_result.highlight if result.respond_to?(:highlight); result }
     
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
