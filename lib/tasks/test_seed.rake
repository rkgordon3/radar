namespace :db do
  namespace :test do
    desc "seed test database"
    task :seed  do
      env = Rails.env
      Rails.env = 'test'
      Rake::Task['db:abort_if_pending_migrations'].invoke
      Rails.application.load_test_seed
      Rails.env = env
    end
  end
end
