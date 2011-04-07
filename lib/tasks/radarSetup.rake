namespace :radar do 
  desc "Setup fresh Radar environment for developments"
  task :setup do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:setup'].invoke
	Rake::Task['db:migrate'].invoke
    Rake::Task['db:data:load'].invoke
	Rake::Task['db:sessions:clear'].invoke
  end
  task :precommit do
	Rake::Task['db:sessions:clear'].invoke
	Rake::Task['db:data:dump'].invoke
  end
	
end