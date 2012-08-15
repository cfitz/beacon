class Section < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  property :title, :type => String

  has_n(:pages).from(:Page)

  has_one :Document
end
