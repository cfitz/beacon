require 'lib/document_importer'
require 'lib/person_importer'

namespace :beacon do
  namespace :import do
    
    task :documents  => :environment do 
      di = DocumentImporter.new
      di.process
    end
    
    task :people  => :environment do 
      pi = PersonImporter.new
      pi.process
    end
    
    task :all  => :environment do 
      Rake::Task["beacon:import:documents"].invoke
      Rake::Task["beacon:import:people"].invoke
    end
    
  end
end
