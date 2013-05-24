FactoryGirl.define do
  factory :field do
    name 'Description'
    namespace
    sql_type 'VARCHAR (255)'
  end
end
