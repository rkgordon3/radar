Radar::Application.routes.draw do

  resources :interested_party_reports

  resources :access_levels

  resources :writing_center_contacts

  resources :study_tables
  
  resources :tutor_contacts

  resources :interested_parties
  
  resources :imports
  
  match "/imports/proc/:id" => "imports#proc_csv"

  resources :task_assignments  
  
  resources  :tests
  
  
  resources :staff_organizations

  resources :organizations

  resources :tasks
  
  resources :tutor_logs
  
  resources :notes do
    get :on_duty_index, :on => :collection
  end

  resources :report_types

  resources :notification_preferences
  match "/notification_preferences/update_user_preferences/:id" => "notification_preferences#update_user_preferences"
  
  
  match "/shifts/update_todo" => "shifts#update_todo"
  
  get "shifts/start_shift"
  match "/shifts/start_shift" => "shifts#start_shift"
  
  match "/reports/forward_as_mail" => "reports#forward_as_mail"

  get "shifts/end_shift"
  match "/shifts/end_shift" => "shifts#end_shift"
  
  match "/buildings/:id" => "buildings#update", :via => :put
  match "/buildings/:id" => "buildings#destroy", :via => :delete

  get "shifts/duty_log"
  match "/shifts/duty_log" => "shifts#duty_log"

  get "shifts/call_log"
  match "/shifts/call_log" => "shifts#call_log"
  
  get "shifts/end_shift"  
  match "/shifts/end_shift" => "shifts#end_shift"  
  
  get "rounds/start_round"
  match "/rounds/start_round" => "rounds#start_round"
  
  get "rounds/end_round"
  match "/rounds/end_round" => "rounds#end_round"
  
  get "reports_query/reports_query"

  match "/to_do_list" => "task_assignments#to_do_list"
  match "/reports/update_common_reasons" => "reports#update_common_reasons"
  match "/reports/update_reason" => "reports#update_reason"
  match "/reports/add_participant/" => "reports#add_participant"
  match "/reports/create_participant_and_add_to_report" => "reports#create_participant_and_add_to_report"
  match "/reports/remove_participant/:id" => "reports#remove_participant"
  match "/students/show_details/:id" => "students#show_details"
  match "/participants/sort_search_results" => "participants#sort_search_results"

  match "/incident_reports/add_participant"         => "reports#add_participant"
  match "/incident_reports/remove_participant/:id"  => "reports#remove_participant"
  
  match "/participant/createNoRedirect" => "participant#createNoRedirect"
  devise_for :staffs
  devise_scope :staff do
    get 'sign_up' => 'devise/sessions#new'
    get '/staffs/*id/edit' => 'devise/registrations#edit'
    resources :staffs, :only => [:index, :show, :destroy]
  end
  
  get "home/landingpage"
  root :to => "home#landingpage"
  
  match "/search/delete_student" => "search#delete_student"
  get "/search/delete_student"

  resources :incident_reports do
    get :on_duty_index, :on => :collection
  end

  resources :maintenance_reports do
    get :on_duty_index, :on => :collection
  end

  
  match "/reports_query/search" => "reports_query#search"
  get "/reports_query/search"
  
  match "/reports_query/search_results" => "reports_query#search_results" 
  get "/reports_query/search_results"
  
 # get "/students/search_students"
  
  match "/students/process_search_parameters" => "students#process_search_parameters" 
  get "/students/process_search_parameters"
    
  match "/index_search" => "reports#index_search"
  
  resources :shifts
  
  resources :rounds 		

  resources :annotations

  resources :participants do
    get  :autocomplete_participant_full_name, :on => :collection
	get  :search, :on => :collection
	post 'search' => :search_results, :on => :collection
  end
  
  resources :reports_query

  resources :report_participant_relationships

  resources :buildings  do
    get :select, :on => :collection
  end
 
  resources :areas  do
    get :add_building, :on => :collection
  end
  resources :student_infractions

  resources :relationship_to_reports
  
  resources :reports  do
	collection do
 	  get :on_duty_index
	  post :new_with_participants
	end
  end

  resources :students do
   
  end
  


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
