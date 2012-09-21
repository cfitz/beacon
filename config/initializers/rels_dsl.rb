module Neo4j
  module Rails
    module Relationships
      class RelsDSL
      
      
      
      
        def last
          self.to_a.last
        end
        
        def persisted?
          true
        end
        
        def to_ary
          self.to_a
        end
        
        def id
          "123"
        end
        
      end
    end
  end
end
      
      