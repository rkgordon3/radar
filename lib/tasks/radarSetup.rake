namespace :radar do 
  desc "Setup fresh Radar environment for developments"
  task :setup do
    
    Rake::Task['db:drop'].invoke
    Rake::Task['db:setup'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:data:load'].invoke
    if ENV['RAILS_ENV'] == 'production'
        Rake::Task["db:fixtures:load FIXTURES=participants.csv"].invoke
    end
    
    Rake::Task['db:sessions:clear'].invoke
  end
  task :precommit do
    Rake::Task['db:sessions:clear'].invoke
    Rake::Task['db:data:dump'].invoke
  end

  namespace :test do
    desc "Setup fresh Radar environment for testing"
    task :setup do
      rake_system("rake db:drop RAILS_ENV=test")
      rake_system("rake db:setup RAILS_ENV=test")
      rake_system("rake db:migrate RAILS_ENV=test")
      rake_system("rake db:data:load RAILS_ENV=test")
      rake_system("rake db:sessions:clear RAILS_ENV=test")
    end
  end
  
end
