
require File.join(Rails.root, "lib", "uuid")

# neo4j paperclip only uses the neo4j logger....that f
module Paperclip
  class << self
    def logger
      Rails.logger
    end
  end
end


Paperclip.interpolates :uuid do |attachment, style|
    attachment.instance.parent_uuid
end




  
Paperclip::Attachment.default_options.merge!(
  :storage => 's3',
  :s3_credentials => YAML.load_file("#{Rails.root}/config/s3.yml"),
  :path => "#{Rails.env}/:uuid/:id/:style/:basename.:extension",
  :bucket => 'wmu-library' )