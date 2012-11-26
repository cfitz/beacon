module Sluggable
   extend ActiveSupport::Concern
    included do
          
       def self.find_sluggable(id)    
          object = send(:find_by_slug, id)
          if object.nil?
             begin
                send(:find, id)
             rescue Java::JavaLang::RuntimeException
               object = nil
             end
          end
          object
        end
 
      # Returns the slug for the url
        def to_param
          if persisted? 
            if slugged?
              return slug
            else
              return neo_id.to_s
            end
          else
             return nil
          end
        end 

      ##
      # This is used to ensure that a model has a slug, which is a URL friendly title/name
      # To make a default 
        def default_name
          nil
        end
  
    # Returns true/false if slug has value
      def slugged?
        !slug.blank?
      end
  

  private

        def ensure_named
          self.name ||= default_name
          return true if self.slug
          return self.name if self.name.blank?
          slugged = name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s # As ASCII
          slugged.gsub!(/[']+/, '') # Remove all apostrophes.
          slugged.gsub!(/\W+/, ' ') # All non-word characters become spaces.
          slugged.squeeze!(' ')     # Squeeze out runs of spaces.
          slugged.strip!            # Strip surrounding whitespace
          slugged.downcase!         # Ensure lowercase.
          # Truncate to the nearest space.
          if slugged.length > 50
            words = slugged[0...50].split(' ')
            slugged = words[0, words.length - 1].join(' ')
          end
          slugged.gsub!(' ', '_')   # Dasherize spaces.
          self.slug = slugged
        end
  
    end #included
  
  
  
  
end