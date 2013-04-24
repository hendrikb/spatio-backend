# encoding: UTF-8
require './lib/reader.rb'
require './lib/reader/csv.rb'
require './lib/reader/csv/wlan_standorte_berlin.rb'

require './lib/reader/rss.rb'

readerCSV = Reader::CSV::WlanStandorteBerlin.new 'data/wlanstandort_final.csv'
stuff = readerCSV.load

# look at stuff now!
require 'pry'; binding.pry

# ------------------------------------

rss_options = {
  parse_articles: true,
  parse_articles_selector: '#spArticleSection',
  input_encoding: 'iso8859-1',
  output_encoding: 'iso8859-1'
}

SponRSS = Reader::RSS.new 'http://www.spiegel.de/reise/index.rss', rss_options
stuff2 = SponRSS.load

# look at stuff2 now!
require 'pry'; binding.pry
