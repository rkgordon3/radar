namespace :radar do 
  desc "Setup fresh Radar environment for developments"
  task :setup do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:setup'].invoke
    Rake::Task['db:data:load'].invoke
	Rake::Task['db:sessions:clear'].invoke
    #rake_system('devisepost.bat')
  end
  task :precommit do
	Rake::Task['db:sessions:clear'].invoke
	Rake::Task['db:data:dump'].invoke
    #rake_system('devisepre.bat')
  end
	
end