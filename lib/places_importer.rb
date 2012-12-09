require 'csv'

# this imports marc records as works into the neo4j db
class PlacesImporter
  def self.process
   
    File.open(File.join(File.dirname(__FILE__), "..", "doc", "continents.csv" ) ).each_line { |d| Place.create!( :name => d.chomp, :place_type => "continent" ) }
    
    CSV.parse(open(File.join(File.dirname(__FILE__), "..", "doc", "places.csv"))).each do |row|
       place = Place.create( :name => row[0].chomp.strip, :place_type => row[1].chomp.downcase.strip )
       
       
       cont = row[2].chomp.strip if row[2]
       unless cont.blank?
         place.located_in << Place.find(:name => cont )
       end
       place.save   
    end
    
    CSV.parse(open(File.join(File.dirname(__FILE__), "..", "doc", "country_list.csv"))).each do |row|
      place = Place.create(:name => row[0].chomp, :place_type => "country", :iso_code => row[1] )
    end
    
    CSV.parse(open(File.join(File.dirname(__FILE__), "..", "doc", "country_list2.csv"))).each do |row|
       search = Place.search(row[0].chomp.strip)
       if search.results.first && search.results.first.name
         place = search.results.first
         puts "#{row[0]} => #{place.name}"
         unless row[3].blank?
           cont = Place.find(:name => row[3].strip )
           cont.has_locations << place
         end
         place.save
       else
         puts row[0] + " => "
       end
    end
    
    
    
    
    end
end