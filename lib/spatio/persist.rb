# encoding: utf-8

module Spatio
  module Persist
    extend self

    def perform(table_name, data)
      table = Class.new(ActiveRecord::Base) do
        self.table_name = table_name
        set_rgeo_factory_for_column(:location, Spatio::GEOFACTORY)
      end

      row = table.new(data)
      raise Spatio::NoLocationError unless row.location
      row.save!
    end
  end
end
