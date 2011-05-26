IF "%devise_dir%"=="" GOTO END
copy "devise views\sessions\sessions_controller.rb" "%devise_dir%\app\controllers\devise\sessions_controller.rb"
copy "devise views\sessions\new.iphone.erb" "%devise_dir%\app\views\devise\sessions\new.iphone.erb"
copy "devise views\sessions\new.html.erb" "%devise_dir%\app\views\devise\sessions\new.html.erb"
copy "devise views\registrations\registrations_controller.rb" "%devise_dir%\app\controllers\devise\registrations_controller.rb"
copy "devise views\registrations\new.html.erb" "%devise_dir%\app\views\devise\registrations\new.html.erb"
copy "devise views\registrations\edit.html.erb" "%devise_dir%\app\views\devise\registrations\edit.html.erb"
copy "devise views\shared\_links.erb" "%devise_dir%\app\views\devise\shared\_links.erb"
GOTO END2
:END
ECHO "devise_dir environment variable must be set, e.g.c:\Ruby192\lib\ruby\gems\1.9.1\gems\devise-1.1.7" "
:END2

