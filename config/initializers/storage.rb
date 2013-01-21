module Neo4j
  module Rails
    module Relationships
      class Storage #:nodoc:
        
        # odd error happening when there's a callback. This fixes it.
       def rm_unpersisted_incoming_rel(rel)
              if @unpersisted_incoming_rels
                @unpersisted_incoming_rels.delete(rel)
                @unpersisted_incoming_rels = nil if @unpersisted_incoming_rels.empty?
              end
       end
            
      end
    end
  end
end