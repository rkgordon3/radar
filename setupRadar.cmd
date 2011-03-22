call bundle install
call rake db:drop RAILS_ENV=development
call rake db:setup 
call rake db:data:load
call rake db:sessions:clear
rails server