class Creator < Neo4j::Rails::Relationship
  property :title, :role, :index => :exact
end