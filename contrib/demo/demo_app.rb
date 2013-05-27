# encoding: UTF-8
require './lib/spatio/reader.rb'
require './lib/spatio/reader/csv.rb'

parameters = { geo_columns: [0],
               title_columns: [0],
               meta_data: { count: [2] },
               url: 'http://userpage.fu-berlin.de/rschaden/historic_crimes.csv',
               col_sep: ',' }
stuff = Spatio::Reader::CSV.perform parameters

# look at stuff now!
require 'pry'; binding.pry

# ------------------------------------
