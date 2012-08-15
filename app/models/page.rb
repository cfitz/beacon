class Page < Neo4j::Rails::Model
  property :page_number, :type => Float
  index :id

  has_one :Document
  has_one :Section
end
