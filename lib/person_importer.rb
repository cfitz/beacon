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
   
  def cleanup(string)
      return string.gsub('"', "").strip.chomp.chomp(".").chomp("-").strip.chomp("/").strip
  end
  
  # this searches ES and either returns a loaded result or creates on
  def search_or_create(klass, query, create = false )
    search = klass.send(:search, query, :load => true)
    result = search.results.first
    obj = result ? result :  klass.send(:new, :name => query )
    obj.save if create
    obj
  end
  
  
  def process
    
    @wmu = CorporateBody.find_by_exact_name("World Maritime University")
    unless @wmu
      @wmu = CorporateBody.create!(:name => "World Maritime University")
    end
    
    
    @csv.each do |row|
      name = cleanup(row[0])
      id = row[1]
      program_name = cleanup(row[2])
      country_name = cleanup(row[3])
      title = name.split(" ").pop
      name.gsub!(title, "").strip!
      
      surname, first_name = name.split(",")
      first_name ||= ""
    
      person = Person.create( :title => title, :first_name => first_name, :surname => surname, :name => "#{first_name.titleize} #{surname.titleize}".strip  )

#      person = search_or_create(Person, name )
            
#      if person.new?        
#        puts "new person : #{name.titleize} "
#        person.name = name.titleize
#        person.title = title
#        person.save
#      else
#        puts "old person: #{name} => #{person.name}"
#        person.title = title
#        person.save
#      end
      
        program = CorporateBody.find_by_exact_name(program_name)
        unless program
          program =  CorporateBody.create!(:name => program_name)
          puts "new program => #{program.name}"
        end
        
        
        program.is_part_of << @wmu
        person.has_membership << program
        person.has_membership_rels.first.member_type = "World Maritime University Alumni"
        
        
        #country = search_or_create(Place, country, true)
        country = Place.find_by_name(country_name)
        unless country
          country = Place.create!(:name => country_name)
        end
        
        person.has_nationality << country
      
      
      
        person.save
        country.save
        program.save
        
        
              
    end
  
    Document.all.each { |d| d.save }
  
  
  end
  
  
  
end