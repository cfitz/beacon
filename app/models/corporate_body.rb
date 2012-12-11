
# a corporate body is a group of people

class CorporateBody < Neo4j::Rails::Model
        
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Sluggable
  
  index :id
  
  property :name, :type => String, :index => :exact
  property :slug, :index => :exact
  has_n(:is_part_of).to(CorporateBody)
  has_n(:members).from(Person, :has_member)
  has_n(:created_work).to(Document).relationship(Creator)
  
  validates :name, :presence => true
  validate :ensure_named, :before => :create
  
  mapping do
      indexes :name, analyzer: 'snowball', boost: 1000
  end
  
  
  
  def _destroy 
     false
   end

  def _new
    false
  end
  
end
