
require File.join(Rails.root, "lib", "uuid")

# neo4j paperclip only uses the neo4j logger....that f
module Paperclip
  class << self
    def logger
      Rails.logger
    end
  end
end


# no longer adding the uuid from the parent. that's too problematic, since an item might be made
# before a parent document...crap. 
Paperclip.interpolates :uuid do |attachment, style|
    attachment.instance.parent_uuid
end

Paperclip::Attachment.default_options.merge!(
  :storage => 's3',
  :s3_credentials => YAML.load_file("#{Rails.root}/config/s3.yml"),
  :path => "#{Rails.env}/:uuid/:id/:basename.:extension",
  :bucket => 'wmu-library',
  :s3_permissions => {
    :original => :private
  } )
  
  
  
#  :attachment, 
#  :storage => :s3, :bucket => 'mybucket',
#  :s3_credentials => {...}, :s3_protocol => 'https', 
#  :s3_permissions => :private,
#  :path => lambda { |attachment| ":id_partition/#{attachment.instance.random_secret}/:filename" },
#  :processors => [:noop]