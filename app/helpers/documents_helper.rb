module DocumentsHelper
  
  def input_to_text(input)
    Nokogiri::XML(input.to_s).root.attributes["value"]
  end
  
  # this takes an item and makes the proper li for it. this is ugly as hell. 
  def render_list_item(item)
    if item.url.include?("catalog.wmu")
      "<li><a href='#{item.url}'><i class='icon-book'></i><b>Koha Record</b></a></li>"
    elsif item.url.include?("docs.google.com")
      if current_user # or item.public?
        "<li><a href='#{item.url}'><i class='icon-file'></i><b>PDF</b></a></li>"
      else
        "<li><b>PDF</b></li>"
      end
    elsif !item.url.include?("missing") # paperclip has a url of 'missing.pgn' if there isn't an attachment
      "<li><a href='#{item.url}'><i class='icon-file'></i><b>External Link</b></a></li>"
    else
      ""
    end    
  end
  
  # this takes an items ennumerable and returns a ol of the items.
  def item_list(items, list = "ul", node_class = 'items_list')
    unless items.nil?
      node_class ? node_class = "class='#{node_class}'" : node_class = '' 
      results = "<#{list} #{node_class}>"
      items.each { |i| results << render_list_item(i) }
      results << "</#{list}>"
      results.html_safe
    end
  end
  
  # this takes a topics ennumerable and returns a list of the topics
  def topics_list topics
    content_tag :dd, :class => 'topics_list' do
      topics.enum_for(:each_with_index).collect { |topic, index| concat( link_to " #{topic.name}#{ ',' unless index == (topics.to_a.size - 1) }", topic  ) }
    end
  end
  
  # this takes a authors ennumerable and returns a list of the topics
   def authors_list authors
     content_tag :dd, :class => 'authors_list' do
       authors.enum_for(:each_with_index).collect { |author, index| concat( link_to " #{author.name}#{ ';' unless index == (authors.to_a.size - 1) }", author  ) }
     end
   end
   
   
   # this determines if there's a pdf to be shown and it's public
   def show_pdf?
      if @document.pdf_item.nil? # there's no pdf, so show nothign
        false
      elsif @document.pdf_item
       true
      elsif @document.pdf_item and current_user # there's a pdf, it's private, but we're logged in, so show it. 
       true
      else # there's a pdf, it's private, and we're not logged in, so no show.  
       false
      end
   end
   
  
 
end
