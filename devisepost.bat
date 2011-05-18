IF "%devise_dir%"=="" GOTO END
copy "devise views\sessions_controller.rb" "%devise_dir%\app\controllers\devise\sessions_controller.rb"
copy "devise views\new.iphone.erb" "%devise_dir%\app\views\devise\sessions\new.iphone.erb"
copy "devise views\registrations_controller.rb" "%devise_dir%\app\controllers\devise\registrations_controller.rb"
copy "devise views\new.html.erb" "%devise_dir%\app\views\devise\registrations\new.html.erb"
copy "devise views\_links.erb" "%devise_dir%\app\views\devise\shared\_links.erb"
GOTO END2
:END
ECHO "devise_dir environment variable must be set, e.g.c:\Ruby192\lib\ruby\gems\1.9.1\gems\devise-1.1.7" "
:END2

