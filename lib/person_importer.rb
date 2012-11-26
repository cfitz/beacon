require 'csv'

# this imports marc records as works into the neo4j db
class PersonImporter
  
  def initialize(csv = File.join(File.dirname(__FILE__), "..", "doc", "students.csv" ) )
     if File.exists?(csv)
       @csv = CSV.read(csv)
     else
      raise ArgumentError, "You must pass CSV"  
     end
   end
  
  
  def process
    
    @wmu = CorporateBody.find_or_create_by!(:name => "World Maritime University")
    
    @csv.each do |row|
      name = row[0]
      id = row[1]
      program_name = row[2]
      country = row[3]
      title = name.split(" ").pop
      name.gsub!(title, "").strip!
      
      search = Person.search "\"#{name}\"", :load => true
      
      
      if search.results.length < 1           
        name = name.titleize
        person = Person.create!(:name => name, :title => title)
      else
        person = search.results.first
        person.title = title
        person.save
      end
      
        program = CorporateBody.find_or_create_by!(:name => program_name )
        program.is_part_of << @wmu
        puts person.name
        person.has_membership << program
        person.has_membership_rels.first.member_type = "World Maritime University Alumni"
        
        
        country = Place.find_or_create_by!(:name => country)
        person.has_nationality << country
      
      
      
        person.save
      
        
        
        
      
    end
  end
  
  
end