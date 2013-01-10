# Based on https://gist.github.com/1182136
# this is to fix some will_paginate issues with Bootstrap
class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
  protected

  def html_container(html)
    tag :div, tag(:ul, html), container_attributes
  end

  def page_number(page)
    tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
  end

  def gap
    tag :li, link('&hellip;'.html_safe, '#', :class => 'disabled')
  end

  def previous_or_next_page(page, text, classname)
    tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
  end
  
end #class BoostrapLinkRenderer

def page_navigation_links(pages, param_name = "page", per_page = 25)
  will_paginate(pages, :param_name => param_name, :per_page => per_page,  :class => 'pagination', :align => "center", :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe)
end


def format_date(date= Date.new )
  date.nil? ? "" : date.year
end

def item_icon(item= "KOHA")
  item.disseminator == "KOHA" ? 'icon-book' : 'icon-file'
end

# makes twitter flash messages look right
# app/helpers/application_helper.rb
def twitterized_type(type)
  case type
    when :alert
      "alert-block"
    when :error
      "alert-error"
    when :notice
      "alert-info"
    when :success
      "alert-success"
    else
      type.to_s
  end
end  
