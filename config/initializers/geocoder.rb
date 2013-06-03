# encoding: utf-8

require 'geocoder'
require 'redis'

Geocoder.configure(
  lookup: :nominatim,

  cache: Spatio.redis,
  timeout: 10
)
