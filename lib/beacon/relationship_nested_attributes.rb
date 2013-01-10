# this adds some methods for dealing with relationships with nested_attributes. 

  module RelationshipNestedAttributes
      extend ActiveSupport::Concern
 
    
        # this is a fix for rails that allows us to destroy relationships without destroying the item.
         def update_nested_attributes(rel_type, attr, options)
            allow_destroy, allow_destroy_relationship, reject_if = [options[:allow_destroy], options[:allow_destroy_relationship], options[:reject_if]] if options
            begin
              # Check if we want to destroy not found nodes (e.g. {..., :_destroy => '1' } ?
              destroy = attr.delete(:_destroy)
              destroy = '0' if destroy == 'false'
              found = _find_node(rel_type, attr[:id]) || Neo4j::Rails::Model.find(attr[:id])
              if allow_destroy && destroy && destroy != '0'      
                found.destroy if found
              elsif allow_destroy_relationship && destroy && destroy != '0'
                _remove_relationship(rel_type, found) if found
              else
                if not found
                  _create_entity(rel_type, attr) #Create new node from scratch
                else
                  #Create relationship to existing node in case it doesn't exist already
                  _add_relationship(rel_type, found) if (not _has_relationship(rel_type, attr[:id]))
                  found.update_attributes(attr)
                end
              end
            end unless reject_if?(reject_if, attr)
          end

          # this removes the relationship from the node.  
          def _remove_relationship(rel_type, node)
            if respond_to?("#{rel_type}_rel")
              send("#{rel_type}=", nil)
            elsif respond_to?("#{rel_type}_rels")
              has_n = send("#{rel_type}")
              has_n.delete( node )
            else
              raise "Invalid relation type: #{rel_type}" 
            end
          end

            
end