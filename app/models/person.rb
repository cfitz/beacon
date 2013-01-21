class Person < Neo4j::Rails::Model
  
  
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include BeaconSearch
  include Sluggable
  
  
  index :id

  property :slug, :index => :exact
  property :title, :type => String, :index => :exact
  
  property :alt_id, :type => String, :index => :exact

  property :name, :type => String, :index => :exact
  property :surname, :type => String, :index => :exact
  property :first_name, :type => String, :index => :exact

  property :created_at, :type => DateTime
  index :created_at

  property :updated_at, :type => DateTime
  index :updated_at
  
  property :person_type, :type => String, :index => :exact



  has_n(:documents_created).from(Document.creators).relationship(Creator)
  has_n(:has_membership).to(CorporateBody).relationship(GroupMember)
  has_n(:has_nationality).to(Place)
  has_one(:user_profile).to(User)
  
  validates :name, :presence => true
  validate :ensure_named, :before => :create
  
  
  
  def self.facets
      [  :nationality_facet, :world_maritime_university_program_facet, :role_facet ]
  end
  
  mapping do
       indexes :name,  :analyzer => 'snowball', :boost => 100
       indexes :name_sort, :type => "string", :index => "not_analyzed"
       
       indexes :world_maritime_university_program_facet, :type => "string", :index => "not_analyzed"
       indexes :nationality_facet, :type => "string", :index =>"not_analyzed"
       indexes :role_facet, :type => "string", :index => "not_analyzed"
  end


  # this configures how tire indexs into Elastic Search
  def to_indexed_json
         json = {
            :name   => name,
            :name_sort => name.gsub(/\s+/, "").downcase,   
            :world_maritime_university_program_facet => self.has_membership.collect { |p| p.name }, 
            :nationality_facet => self.has_nationality.collect { |n| n.name },
            :role_facet => self.roles.collect { |r| r.titleize }        
          }
          json.to_json
  end



  def roles
    self.documents_created_rels.collect { |rel| rel.role } + self.has_membership_rels.collect { |rel| rel.member_type }
  end



  def _destroy 
    false
  end
  
 def _new
   false
 end


 
  
end
