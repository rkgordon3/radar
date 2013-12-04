namespace :db do
  namespace :test do
    desc "seed test database"
    task :seed  => :environment do
        Rake::Task['db:abort_if_pending_migrations'].invoke
        Rails.application.load_test_seed
    end
  end
end
