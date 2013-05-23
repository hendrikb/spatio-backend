class Namespace < ActiveRecord::Base
  has_many :fields

  validate :name, unique: true
end
