namespace :radar do 
  namespace :test do
    desc "Setup fresh Radar environment for testing"
    task :setup do
      Rake::Task['db:drop RAILS_ENV=test'].invoke
      Rake::Task['db:setup RAILS_ENV=test'].invoke
  	  Rake::Task['db:migrate RAILS_ENV=test'].invoke
      Rake::Task['db:data:load RAILS_ENV=test'].invoke
  	  Rake::Task['db:sessions:clear RAILS_ENV=test'].invoke
    end
	end
end