class Term < Neo4j::Rails::Model
  property :name, :type => String, :index => :exact
  
  has_n(:is_alias).from(Place, :aliases)
  
  
end