class Annotation < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  property :title, :type => String
  property :content, :type => String

  has_n(:pages).from(:Page)

end
