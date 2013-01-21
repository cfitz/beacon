# a topic is anythign that is not a person or place. A physical object or abstract idea. 
class Topic < Neo4j::Rails::Model
 
  include BeaconSearch
  include Sluggable
  

  property :name, :type => String, :index => :exact
  property :slug, :index => :exact
  
  has_n(:documents).from(:Document, :topics )
  has_n(:terms)

  property :created_at, :type => DateTime
  index :created_at
  property :updated_at, :type => DateTime
  index :updated_at

  validates :name, :presence => true
  validate :ensure_named, :before => :create

  
  def self.facets
      [  :world_maritime_university_program_facet ]
  end


  mapping do
      indexes :name, analyzer: 'snowball', boost: 100
      indexes :world_maritime_university_program_facet, :type => "string", :index => "not_analyzed"
      indexes :related_documents, :type => "integer"
  end
  
  
  # this configures how tire indexs into Elastic Search
  def to_indexed_json
         json = {
            :name   => name,  
           :name_sort => name.gsub(/\s+/, "").downcase,               
            :world_maritime_university_program_facet => world_maritime_university_programs,
            :related_documents => self.documents.to_a.size
          }
          json.to_json
  end
  
  # can we build a cypher q to grab programs related to this? 
  # this is really awful. 
  def world_maritime_university_programs
    programs = []
    self.documents.each do |doc| 
      doc.creators.each do |creator| 
       creator.has_membership.each { |prog| programs << prog.name }
     end
   end
   programs.uniq
  end




  def _destroy 
    false
  end


end
