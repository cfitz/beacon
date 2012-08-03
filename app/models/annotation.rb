class Annotation < Neo4j::Rails::Model
  property :title, :type => String
  property :content, :type => String

  has_n(:pages).from(:Page)

end
