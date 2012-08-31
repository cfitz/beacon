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
      
      p = Person.search name, :load => true
      p = p.first
      
      
      if p.nil?      
        
        title = name.split(" ").pop
        name.delete!(title).strip!
        name = name.titleize
        p = Person.create!(:name => name, :title => title)
     end
      
        program = CorporateBody.find_or_create_by!(:name => program_name )
        program.is_part_of << @wmu
        puts p.name
        p.has_membership << program
        p.has_membership_rels.first.member_type = "World Maritime University Alumni"
      
        p.save
      
        
        
        
      
    end
  end
  
  
end