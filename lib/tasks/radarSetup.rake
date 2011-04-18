namespace :radar do 
  desc "Setup fresh Radar environment for developments"
  task :setup do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:setup'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:data:load'].invoke
    puts "data loaded"
    Rake::Task['db:sessions:clear'].invoke
    puts "session cleared"
    rake_system('devisepost.bat')
    puts "devise done"
  end
  task :precommit do
    Rake::Task['db:sessions:clear'].invoke
    Rake::Task['db:data:dump'].invoke
    rake_system('devisepre.bat')
  end
  
end