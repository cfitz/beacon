class WorkItem < Neo4j::Rails::Relationship
  property :format, :index => :exact
end