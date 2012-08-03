module DocumentsHelper
  
  def input_to_text(input)
    Nokogiri::XML(input.to_s).root.attributes["value"]
  end
 
 
end
