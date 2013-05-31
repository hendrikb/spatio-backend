# encoding: utf-8

FactoryGirl.define do
  sequence :name do |n|
    "format_definition_#{n}"
  end

  factory :format_definition do
    name
    importer_class 'RSS'
    importer_parameters { { title_columns: ['title'], geo_columns: ['title'] } }
  end
end
