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
  

end
