module BeaconSearch
    
    def self.included(base)
        base.extend(ClassMethods)
    end
      
    module ClassMethods
      def elastic_search(params={})
          
           
           page = params[:page] ? params[:page] : 1
           per_page = params[:per_page] ? params[:per_page] : 10
           request_facets = params[:facet] ? params[:facet].compact : []
           request_query = params[:query] ? params[:query].compact : "*"
           
          
           
           facet_filters = request_facets.collect do |f|
             facet, value = f.split(":")
             lambda { |boolean| boolean.must { term facet.to_sym, value } }
           end
           
           self.facets ? defined_facets = self.facets : defined_facets = []
             
           search = Document.tire.search(:page => page, :per_page => per_page, :load=> true) do
               query do
                 boolean do must { string request_query, :default_operator => "AND" } if request_query end
                 facet_filters.each { |ff| boolean  &ff }
               end
               
               defined_facets.each { |f| facet f.to_s do terms f.to_sym  end  }
               
               
                #raise to_json
                # raise to_curl
          end #tire.search
          
          return search
      
      end #elastic_search
    end #ClassMethods
  
end #beacon
