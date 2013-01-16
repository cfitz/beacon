require File.join(File.dirname(__FILE__), '../..', 'lib/bootstrap_link_renderer')

module ApplicationHelper

  ::BootstrapLinkRenderer
  
  # returns a friendly name for the omni_auth provider
  def provider_name(provider)
    names = { "google_oauth2" => "World Maritime University Log-In", "facebook" => "Facebook"}
    names[provider] ? names[provider] : provider.titleize
  end
  
  # This build the list for the facets. 
  def facet_list(facet_label, facet_values)
    facet_page = params[:"#{facet_label}_page"] ? ( params[:"#{facet_label}_page"].to_i ) : 1
    facet_range = ( ( facet_page * 10 ) - 1 )
    
    list = content_tag(:li, :class => "nav-header") { concat(facet_label.gsub("_facet", "").pluralize.titleize) }
    facet_values[0..facet_range].each { |term| list << term_list(facet_label, term)   }
    list << facet_more_link(facet_label) if facet_values.length > ( facet_range + 1)
    list
  end
  
  # this returns a li for the term in the facet
  def term_list(facet_label, term )
      facet_term = "#{facet_label}:#{term['term']}"
      params_facet = params[:facet] ? params[:facet] : []
       if params_facet.include?(facet_term)
         remove_facet_li(facet_term, term["count"])
       else 
         add_facet_li(facet_term, term["count"])
       end
  end
     
  
  # this adds a li to remove the facet from the query
  def remove_facet_li(facet_term, facet_count)
    
    facets = params[:facet].clone
    facets.delete(facet_term)
    new_params =  { :controller => params[:controller], :action => params[:action], :facet => facets }
    new_params[:q] = params[:q] if params[:q]  
    
    return content_tag(:li, :class => "active") {  
            link_to(  new_params ) {
                  content_tag(:i, "", :class => "icon-remove icon-white") + "#{facet_term.split(":").last}"
            }
    }
  end
  
  def add_facet_li(facet_term, facet_count)
    facets = params[:facet] ? params[:facet].clone : []
    facets << facet_term
    new_params =  { :controller => params[:controller], :action => params[:action], :facet => facets }
    new_params[:q] = params[:q] if params[:q]
    
    return content_tag(:li) do
        link_to( "#{facet_term.split(":").last}", new_params ) +
          content_tag(:span, facet_count, :class => "count badge")
    end
    
  end
  
  def facet_more_link( facet_label )
    params_clone = params.clone
    params_clone[:"#{facet_label}_page"] = params[:"#{facet_label}_page"] ?  ( params[:"#{facet_label}_page"].to_i + 1 ) : 2
    link_to("More", params_clone)
  end
  
    
  #takes a date an makes sure it doesn't look stupid
  def pretty_date(date)
    dt = DateTime.parse(date)
    if dt.month == 1 && dt.day == 1
      return "(#{dt.year})"
    else
      return "(#{date})"
    end
  rescue
    return "Unknown"
  end
 
  # this returns a list to be used in index views to show associated items. it takes a neo4j traversal, which is just a fancy ennumerable
  def associated_index_list(assoc_objs, list_class = "#{assoc_objs.first.class.to_s.downcase}_list")
    unless assoc_objs.first.nil?
      results = "<ul class='associated_items #{list_class}' >"
      assoc_objs.each { |obj| results << "<li>#{ link_to obj.name, obj  }</li>" }
      results << "</ul>"
      results.html_safe
    end
  end
  
 
   
 
end
