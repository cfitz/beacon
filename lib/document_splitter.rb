require 'rubygems'
require 'docsplit'


def convert_pdf(file, text_dir = File.join(".", "text"))
  
    Docsplit.extract_images( file, :size => ['1000x', '700x', '180x' ])
    Docsplit.extract_text(file, :ocr => false, :output => text_dir, :pages => 'all' )
    Docsplit.extract_text(file, :ocr => false )

end

#AWS = "/mnt/wmu-library/development"
AWS = "/Users/chrisfitzpatrick/Documents/wmu_online/Dissertations"

File.read("/tmp/pdfs.txt").each_line do |pdf|
  pdf.chomp!
  
  file = File.basename(pdf)
  dir = File.join(AWS, File.basename(File.dirname(pdf)))
  puts pdf
  
  unless File.exists?(File.join(dir,"text"))
    t1 = Time.now
    Dir.chdir(dir)
    Dir.mkdir("text")
    convert_pdf(file)
    Dir.chdir("..")
    t2 = Time.now
    delta = t2 - t1
    puts delta
  end

end