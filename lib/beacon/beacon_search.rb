module BeaconSearch
    extend ActiveSupport::Concern
    
    included do
        include Tire::Model::Search
        include Tire::Model::Callbacks
    end
      
    module ClassMethods
      
      # this is used when searching for a 
      def elastic_search(params={})
          params = format_params(params)
          search = self.tire.search(:page => params[:page], :per_page => params[:per_page], :load=> true ) do
               query do
                 boolean do must { string params[:request_query], :default_operator => "AND" } if params[:request_query] end
                 params[:facet_filters].each { |ff| boolean  &ff }
               end
               params[:facet_query].each_pair { |f, size| facet f.to_s do terms f.to_sym, :size => size   end  } 
               # raise to_json  #for debugging
               # raise to_curl # for debugging
               
               if params[:sort_by] && params[:order_by]
                 sort { by params[:sort_by].to_sym, params[:order_by] }
               end 
               
          end #tire.search
    #      search.results.collect! { |d| d.load }
          return search
      end #elastic_search
      
      
      # this is used to search across multiple indexes
      def multi_index_elastic_search(params={})
        params = format_params(params)
        
        search = Tire.search params[:indexes], :load => false, :from => params[:offset] do 
            query do
              boolean do
                should { match :name, "#{params[:q]}*", :type => :phrase_prefix }
                should { match :content, params[:q], :type => :phrase}
              end
            end
            facet "item_type" do terms :_type end
            highlight :content, :title
            sort { by "_score"}

         end
      end
      
      # a real nasty method to format request paramters to pass on to the elastic_search
      def format_params(params)
        
         # this is just used for multi_index search
         params[:indexes] ||= ['documents', 'people', 'topics', 'places' ]
         
        
         # return loaded models?
          params[:load] ||= true
         
         # will_paginate settings
        params[:page] ||= 1
        params[:per_page] ||=  25
        params[:offset] =  ( ( params[:page].to_i - 1) * params[:per_page].to_i)

         # sort by
         params[:sort_by], params[:order_by] = params[:sort].split(":") if params[:sort]
         params[:order_by] = "desc" unless params[:order_by] == "asc"

         # facet filters and query
         params[:facet] ||= []
         params[:facet].compact!

         params[:request_query] = params[:q] ? params[:q].compact : "*"
         
         # facet filtering/limits
         params[:facet_filters] = params[:facet].collect do |f|
           facet, value = f.split(":")
           lambda { |boolean| boolean.must { term facet.to_sym, value } }
         end
         
          # facets to be returned
          params[:request_facets] ||= self.facets
          params[:facet_query] = {} 
          params[:request_facets].each { |f| params[:facet_query][f] = params[:"#{f}_page"] ? ( ( params[:"#{f}_page"].to_i * 10 ) + 1 ) : 11  }
          
          return params
        end #format_params
      
      
    end #ClassMethods
  
end #beacon
