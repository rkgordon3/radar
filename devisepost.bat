IF "%devise_dir%"=="" GOTO END
copy "devise views\sessions_controller.rb" "%devise_dir%app\controllers\devise\sessions_controller.rb"
copy "devise views\new.iphone.erb" "%devise_dir%app\views\devise\sessions\new.iphone.erb"
GOTO END2
:END
ECHO "Devise Dir Not Found"
:END2

