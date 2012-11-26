require 'marc'
require 'open-uri'

# this imports marc records as works into the neo4j db
class DocumentImporter
  
  attr_accessor :marc
  
  
  def initialize(marc = File.join(File.dirname(__FILE__), "..", "doc", "works.mrc" ) )
    if File.exists?(marc)
      @marc = MARC::Reader.new(marc)
    else
     raise ArgumentError, "You must pass a MARC file."  
    end
  end
  

  
  def cleanup(string)
    return string.gsub('"', "").strip.chomp.chomp(".").chomp("-").strip.chomp("/").strip
  end
 
  
  
  def process
    for record in @marc
      
    # if record.fields('856').first and record.fields('856').first["u"]
      
      title = ""
      date = ""
      biblio = record["999"]["c"]

      subfields = "abfgknps".each_char do |sub|
        if record["245"] && record["245"][sub]
          title << record["245"][sub] + " "
        end
      end
      title = cleanup(title)
      
      if record["260"] && record['260']['c']
          date = Date.new(record["260"]["c"].match(/(19|20)\d\d/).to_s.to_i)
      elsif record['090'] && record["090"]['a']
          date = Date.new(record['090']['a'].match(/(19|20)\d\d/).to_s.to_i)
      end 

      
      work = Document.create!(:title => title, :uuid => biblio )
      
      unless date.nil?
        work.date = date
      end

      record.fields("100").each do |onehund|
        if onehund["a"]
          name =  cleanup(onehund['a'].chomp(".").titleize)
          p = Person.find_or_create_by!(:name => name)
          creator = Creator.new(:creators, work, p, {:role => "author" })
        end
      end
      
      
      work.save
      item = work.items.create(:url => "http://catalog.wmu.se/cgi-bin/koha/opac-detail.pl?biblionumber=#{biblio}", :item_type => "KOHA")
      item.save

      record.fields('856').each do |e56|
        url = e56["u"]
        
        if url
          # http://s3-eu-west-1.amazonaws.com/wmu-library-content/Dissertations/U-Wje8mmUr3O-tUXaEApZw/Herbert%20Christian.pdf
          item = work.items.create( :item_type => "PDF", :url => url )
          item.save
        end        
      end
      work.save
      
     
      
      record.fields("650").each do |six50|
         terms = []
       
         if six50["a"]
            terms << Concept.find_or_create_by!(:name => cleanup( six50["a"]) ) 
         end
         if six50["x"]
            terms << Concept.find_or_create_by!(:name => cleanup( six50["x"]) ) 
         end     

         if six50["z"]
           terms << Place.find_or_create_by!(:name => cleanup( six50["z"]) )
         end
         
          term = terms.collect{|t| t.name}.join(" ")
         
          topic = Topic.find_or_create_by!(:name => term )
         
          terms.each do |t|
           topic.terms << t
          end
          topic.save
          work.topics << topic
         
         
      end

      work.save 
 
    
    
  #   end
    end #for record in marc
    
    t = Thing.create!(:name => "crap")
    t.delete
    
  end # process
  
end
