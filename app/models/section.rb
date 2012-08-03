class Section < Neo4j::Rails::Model
  property :title, :type => String

  has_n(:pages).from(:Page)

  has_one :Document
end
