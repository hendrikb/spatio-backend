require 'sinatra'
require 'sinatra/activerecord'

ENV['RACK_ENV'] ||= 'development'

def conf(file)
  YAML.load_file('config/' + file).fetch(settings.environment.to_s)
end

ActiveRecord::Base.establish_connection conf('database.yml')

require_relative 'models/state.rb'
require_relative 'models/community.rb'
require_relative 'models/district.rb'
require_relative 'models/format_definition.rb'
