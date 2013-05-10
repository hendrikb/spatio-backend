namespace :spatio do
  namespace :db do
    desc 'Load the seed data from db/seeds.rb'
    task :seed do
      load './db/seeds.rb'
    end
  end
end
