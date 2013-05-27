class Import < ActiveRecord::Base
  validates_presence_of :url
  validates_presence_of :namespace
  validates_presence_of :format_definition

  belongs_to :format_definition
end
