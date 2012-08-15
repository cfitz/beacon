module ApplicationHelper

  # Based on https://gist.github.com/1182136
  class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
    
  end #class BoostrapLinkRenderer

  def page_navigation_links(pages)
    will_paginate(pages, :class => 'pagination', :align => "center", :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe)
  end
  
  def format_date(date= Date.new )
    date.nil? ? "" : date.year
  end
  
  def item_icon(item= "KOHA")
    item.disseminator == "KOHA" ? 'icon-book' : 'icon-file'
  end
  

  
  def render_sign_in
    result = "<li class='dropdown pull-right' id='signin'>"
    result << "<a href='#' class = 'dropdown-toggle' data-toggle ='dropdown'>Sign In
      <b class='caret'></b></a>"
    result << "<ul class='dropdown-menu'><li>#{link_to 'with Google', user_omniauth_authorize_path(:google_oauth2)}</li><li>#{ link_to 'with Beacon', new_user_session_path}</li></ul>"
    result << "</li>"
    result.html_safe
  end
  
  def render_sign_out
    result = "<li class='dropdown pull-right' id='signout'>"
    result << "<a href='#' class='dropdown-toggle' data-toggle ='dropdown'>My Account
    <b class='caret'></b>
    </a>"
    result << "<ul class='dropdown-menu'><li>#{ link_to('Sign Out', destroy_user_session_path, :method => :delete) }</li></ul>"
    result << "</li>"
    result.html_safe
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
