module BeaconSearch
    
    def self.included(base)
        base.extend(ClassMethods)
    end
      
    module ClassMethods
      
      def elastic_search(params={})
         
         # will_paginate settings
         page = params[:page] ? params[:page] : 1
         per_page = params[:per_page] ? params[:per_page] : 25

         # sort by
         sort_by, order_by = params[:sort].split(":") if params[:sort]

         order_by = "desc" unless order_by == "asc"

         # facet filters and query
         limit_facets = params[:facet] ? params[:facet].compact : []
         request_query = params[:q] ? params[:q].compact : "*"
         
         # facet filtering/limits
         facet_filters = limit_facets.collect do |f|
           facet, value = f.split(":")
           lambda { |boolean| boolean.must { term facet.to_sym, value } }
         end
         
          # facets to be returned
          request_facets = params[:request_facet] ? params[:request_facet] : self.facets
          facet_query = {} 
          request_facets.each { |f| facet_query[f] = params[:"#{f}_page"] ? ( ( params[:"#{f}_page"].to_i * 10 ) + 1 ) : 11  }
          
          
          search = self.tire.search(:page => page, :per_page => per_page, :load=> true) do
               query do
                 boolean do must { string request_query, :default_operator => "AND" } if request_query end
                 facet_filters.each { |ff| boolean  &ff }
               end
               facet_query.each_pair { |f, size| facet f.to_s do terms f.to_sym, :size => size   end  } 
               # raise to_json  #for debugging
               # raise to_curl # for debugging
               
               if sort_by && order_by
                 sort { by sort_by.to_sym, order_by }
               end 
               
          end #tire.search
          
    #      search.results.collect! { |d| d.load }
          
          return search
      
      end #elastic_search
    end #ClassMethods
  
end #beacon
