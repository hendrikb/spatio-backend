require 'sinatra'
require 'sinatra/activerecord'
require_relative  'spatio'

ENV['RACK_ENV'] ||= 'development'

def conf(file)
  YAML.load_file('config/' + file).fetch(settings.environment.to_s)
end

ActiveRecord::Base.establish_connection conf('database.yml')

require_relative 'models/state'
require_relative 'models/community'
require_relative 'models/district'
require_relative 'models/locality'
require_relative 'models/format_definition'
require_relative 'models/namespace'
