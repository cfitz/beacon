require 'marc'
require 'open-uri'
require 'csv'

# this imports marc records as works into the neo4j db
class DocumentImporter
  
  attr_accessor :marc
  attr_accessor :csv
  
  
  def initialize(marc = File.join(File.dirname(__FILE__), "..", "doc", "dissertations.mrc" ) )
    if File.exists?(marc)
      @marc = MARC::Reader.new(marc)
      @csv = CSV.open("/tmp/name_list.csv", "w")
    else
     raise ArgumentError, "You must pass a MARC file."  
    end
  end
  

  
  def cleanup(string)
    return string.gsub('"', "").delete(".").delete("/").strip.chomp.chomp("-").strip
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
          date = record['260']['c']
      elsif record["591"] && record["591"]["a"]
        date =  record["591"]["a"]
      elsif record['090'] && record["090"]['a']
        date = record['090']['a'].match(/(19|20)\d\d/).to_s
      end 
      
      date = date.to_s.match(/(19|20)\d\d/).to_s

      
      work = Document.create!(:title => title, :uuid => biblio )
      
      unless date.nil?
        work.date = date
      end

      record.fields("100").each do |onehund|
        if onehund["a"]
          name =  cleanup(onehund['a'].chomp(".").titleize)
          personSearch = Person.search(name.delete("[]"))
          if !personSearch.results.first.nil? && personSearch.results.first._score.to_i > 73
            p = personSearch.results.first.load
            creator = Creator.new(:creators, work, p, {:role => "author" })
          elsif !personSearch.results.first.nil?
            big_score = personSearch.results.first._score.to_s
            per = personSearch.results.shift          
            names = ""
            personSearch.results.each { |p| names << "#{p["name"]} (#{p["_score"]}) ;" }
            
            @csv << [ big_score, name,  per["name"], names, "http://catalog.wmu.se/cgi-bin/koha/opac-detail.pl?biblionumber=#{biblio}" ]
            
          else
            @csv <<  [0, name, "" , "http://catalog.wmu.se/cgi-bin/koha/opac-detail.pl?biblionumber=#{biblio}"] 
          end
        end
      end
      
      
      work.save
      item = work.items.create(:url => "http://catalog.wmu.se/cgi-bin/koha/opac-detail.pl?biblionumber=#{biblio}", :item_type => "Print")
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
      
     
      places = []
      topics = []
      
      record.fields("650").each do |six50|
         terms = []
       
         if six50["a"]    
            terms << cleanup( six50["a"])
         end
         if six50["x"]
            terms << cleanup( six50["x"]) 
         end     
        
        term = terms.join(" ")
        topic = term.titleize
        
        topics << topic

        if six50["z"] 
          places << cleanup(six50["z"].titleize)
        end
      
         
      end
      work.save 
        
      places.uniq!
      places.each do |place| 
        search = Place.search(place)
        if search.results.first and search.results.first.name
          found_place = search.results.first.load
          work.topics << found_place
        else
          puts "NOT FOUND => #{place}"
        end
      end

      topics.uniq!
      topics.each do |topic| 
        existing_topics = work.topics.to_a.collect { |t| t.name }
        unless existing_topics.include?(topic)
          work.topics << Topic.find_or_create_by!(:name => topic ); 
          work.save
        end
      end
      
      work.save 
 
    
    
  #   end
    end #for record in marc
    
    # update the indexes
    Topic.all.each { |t| t.save }
    Person.all.each { |t| t.save }
    Place.all.each { |t| t.save }
    
    
    return true
    
  end # process
  
end
