require 'marc'
require 'pdf-reader'
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
    return string.strip.chomp.chomp(".").chomp("-").strip.chomp("/").strip
  end
  
  def get_content(url)
     %x|wget -c '#{url}' -O '/tmp/pdf.pdf'|
    reader = PDF::Reader.new(open("/tmp/pdf.pdf"))
    reader.text
  rescue
    nil
  end
  
  
  def process
    for record in @marc
      
      title = ""
      date = ""
      biblio = record["999"]["c"]

      subfields = "abfgknps".each_char do |sub|
        if record["245"][sub]
          title << record["245"][sub] + " "
        end
      end
      title = cleanup(title)
      
      if record["260"] && record['260']['c']
          date = Date.new(record["260"]["c"].match(/(19|20)\d\d/).to_s.to_i)
      elsif record['090']['a']
          date = Date.new(record['090']['a'].match(/(19|20)\d\d/).to_s.to_i)
      end 

      
      work = Document.create!(:title => title, :id => biblio ).prepare!
      
      
      unless date.nil?
        work.date = date
      end

      record.fields("100").each do |onehund|
        if onehund["a"]
          puts onehund['a'].chomp(".").titleize 
          work.creators << Person.find_or_create_by!(:name => onehund['a'].chomp(".").titleize )
        end
      end
      
      
      
      work.items << Item.create!(:uri => "http://catalog.wmu.se/cgi-bin/koha/opac-detail.pl?biblionumber=#{biblio}", :item_type => "KOHA")

      record.fields('856').each do |e56|
        url = e56["u"]
        
        if url.include?("s3-eu-west-1.amazonaws.com")
          # http://s3-eu-west-1.amazonaws.com/wmu-library-content/Dissertations/U-Wje8mmUr3O-tUXaEApZw/Herbert%20Christian.pdf
          url = url.gsub("http://s3-eu-west-1.amazonaws.com/wmu-library-content/", '')
          file = File.join('/Users/chrisfitzpatrick/Documents/wmu_online', url)
          pdf = Dir.glob(File.join(File.dirname(file), '*.pdf') ).first
          
          item = Item.create( :item_type => "PDF")
          item.attachment = File.new(pdf)
          work.items << item
          item.save
        
          # content = get_content(url)
          #work.content = content unless content.nil? 
        end
        
        
        
      end

      record.fields("650").each do |six50|
         puts six50
         if six50["a"]   
            work.topics << Concept.find_or_create_by!(:name => cleanup( six50["a"]) )
         end
         if six50["x"]
           work.topics << Concept.find_or_create_by!(:name => cleanup(six50["x"]) )
         end
         if six50["z"]
           work.topics << Place.find_or_create_by!(:name => cleanup(six50["z"]) )
         end


      end

      work.save 
 
    
    
    
    end
  end
  
end
