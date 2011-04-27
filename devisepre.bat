IF "%devise_dir%"=="" GOTO END
copy "%devise_dir%app\controllers\devise\sessions_controller.rb" "devise views\sessions_controller.rb"
copy "%devise_dir%app\views\devise\sessions\new.iphone.erb" "devise views\new.iphone.erb"
copy "%devise_dir%app\controllers\devise\registrations_controller.rb" "devise views\registrations_controller.rb"
copy "%devise_dir%app\views\devise\registrations\new.html.erb" "devise views\new.html.erb"
copy "%devise_dir%app\views\devise\shared\_links.erb" "devise views\_links.erb"
GOTO END2
:END
ECHO "Devise Dir Not Found"
:END2
