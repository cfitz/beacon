class Topic < Neo4j::Rails::Model

  property :name, :type => String, :index => :exact
  has_n(:terms)

end
