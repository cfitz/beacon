class Search
  include BeaconSearch
  
  # this is a convenince wrapper for the BeaconSearch.multi_index_elastic_search method. 
  # right now, there's a need to manually load the results and add the highlights. this might go 
  # away in future versions of Tire. 
  def self.multi_index_search(params)
    params[:q] ||= ""
    search = Search.multi_index_elastic_search(params)       
    search.results.results.collect! { |es_result| result = es_result.load; result.highlight = es_result.highlight if result.respond_to?(:highlight); result }
    return search.results  
  end
  
  # right now, we're not returning facets on Multi Index Searches....
  def self.facets
    []
  end
  
end