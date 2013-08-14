require 'rexml/document'
include REXML


Dir.glob("*.html") do |f|
  xmlfile = File.new(f)
  xmldoc = Document.new(xmlfile)
  root = xmldoc.root

  xmldoc.elements.each("title") do
     |e| puts "Movie Title : " + e
  end
end
