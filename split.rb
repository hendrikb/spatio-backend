#!/usr/bin/env ruby



require 'nokogiri'
require 'csv'


def parse
  htmlfile = File.new "tmp/386784.html"
  CSV.open("dumps.csv", "wb",skip_blanks: true, force_quotes: true, headers: :first_row) do |csv|
    csv << [ "title", "district", "content" ]

    Dir.glob("tmp/*.html") do |f|
      htmlfile = File.new(f)
      doc = Nokogiri::HTML(htmlfile)

      title = begin nn(doc.css("#bomain_content h2").first.content) rescue nil end
      district = begin nn(doc.css("#bomain_content h3").first.content) rescue "Berlin" end
      content = begin nn(doc.css("#bomain_content .bacontent .c1").first.content) rescue nil end
      date = begin nn(doc.css("#bomain_content .datum").first.content) rescue nil end
      csv << [ title, district, content, date ]
    end
  end
end

def nn str
  str.gsub("\n"," ").strip
end

parse
