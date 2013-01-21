require 'marc'
require 'rtika'
require "google_drive"
require 'tempfile'


# this imports marc records as works into the neo4j db
class DocumentIndexer


  GDRIVE_USER = "library@wmu.se"
  GDRIVE_PASSWORD = "Mp4L!ie2r"
  
  attr_accessor :session, :collection
  
  
  def initialize()
    @session = GoogleDrive.login(GDRIVE_USER, GDRIVE_PASSWORD)
    @documents = Document.all.to_a.collect { |d| d if d.pdf_item } #we only want to index pdf
    @documents.compact!
    @collection = collection_hash( @session.root_collection.files )
  end

  def index
    @documents.each do |d|
      pdf = d.pdf_item
      if @collection[ pdf.url  ]
        d.content = DocumentIndexer.get_content( @collection[pdf.url]  )
        puts "indexing #{d.id} => #{d.save}"
      end
    end
  end

  # this gets teh fulltext from teh googledoc pdf
  def self.get_content(file)
      tmpfile = Tempfile.new(rand(1000000000).to_s)
      file.download_to_io(tmpfile)
      result = RTika::FileParser.parse(tmpfile.path)
      tmpfile.close
      tmpfile.unlink
      result.content
  end

 
protected

  def collection_hash(files)
    cHash = {}
    files.each { |f| f.is_a?(GoogleDrive::Collection) ? cHash.merge!(collection_hash(f.files)) : cHash.merge!(file_value_pair(f)) }    
    cHash
  end
  
  def file_value_pair(file)
    { file.human_url => file }
  end
 
end