IF "%devise_dir%"=="" GOTO END
copy "%devise_dir%app\controllers\devise\sessions_controller.rb" "devise views\sessions_controller.rb"
copy "%devise_dir%app\views\devise\sessions\new.iphone.erb" "devise views\new.iphone.erb"
GOTO END2
:END
ECHO "Devise Dir Not Found"
:END2
