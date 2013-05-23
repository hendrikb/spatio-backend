class Namespace < ActiveRecord::Base
  validate :name, unique: true
end
