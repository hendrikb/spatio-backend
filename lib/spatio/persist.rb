# encoding: utf-8

module Spatio
  module Persist
    extend self

    # Saves the Hash of data into the PostGIS table named table_name
    def perform(table_name, data)
      table = Class.new(ActiveRecord::Base) do
        self.table_name = table_name
        set_rgeo_factory_for_column(:location, Spatio::GEOFACTORY)
        set_primary_key 'uuid'
      end

      row = table.new(data)
      row[:uuid] = data[:uuid]
      raise Spatio::NoLocationError unless row.location
      row.save!
    end
  end
end
