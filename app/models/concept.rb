#
# A concept is term that expresses and idea. Anything that's not a person, place, or thing....
#

class Concept < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Sluggable
  
  
  property :name, :type => String, :index => :exact
  property :slug, :type => String, :index => :exact
  validate :ensure_named, :before => :create
  validates :name, :presence => true


  mapping do
      indexes :name, analyzer: 'snowball', boost: 100
  end

end
