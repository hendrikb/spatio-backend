# encoding: utf-8

FactoryGirl.define do
  factory :import do
    name 'Open Street Crime Berlin'
    namespace 'fub.osc'
    url 'www.example.com/test_rss.xml'
    format_definition
  end
end
