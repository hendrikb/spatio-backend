ENV['RACK_ENV'] = 'test'

SPEC_ROOT = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(SPEC_ROOT, '..', 'lib'))
$LOAD_PATH.unshift SPEC_ROOT

require 'spatio'
