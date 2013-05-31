# encoding: utf-8

FactoryGirl.define do
  factory :format_definition do
    name 'osc_berlin'
    importer_class 'RSS'
    importer_parameters { { title_columns: ['title'], geo_columns: ['title'] } }
  end
end
