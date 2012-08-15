class WorkItem < Neo4j::Rails::Relationship
  include Neo4jrb::Paperclip
  
  
  property :format, :index => :exact
end