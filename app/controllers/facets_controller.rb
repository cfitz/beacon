## this gets the facets for a specific model

# refactor this out. we should make this in the specific klass controllers...

class FacetsController < ApplicationController
  # GET /facets/:model/:facet => /facets/people/nationality_facet
  def index
    klass = params[:model]
    request_facet = params[:request_facet]
    params[:facets_size] = 25
    query = klass.titleize.constantize.send :elastic_search, params 
    @results_facets = query.facets[request_facet]
    
    respond_to do |format|
         format.html # index.html.erb
    end
    
    
  end
end