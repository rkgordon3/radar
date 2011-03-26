Radar::Application.routes.draw do
  get "reports_query/reports_query"

  devise_for :staffs
  
  get "home/landingpage"

  get "search/search"
  
  root :to => "home#landingpage"
	
  get "search/report_search"
  
  root :to => "home#landingpage"
		
  get 'search/autocomplete_student_full_name'
  
  match "/search/update_list" => "search#update_list"
  get "/search/update_list"
  
  match "/search/delete_student" => "search#delete_student"
  get "/search/delete_student"
  
  match "/search/go_to_student" => "search#go_to_student"
  get "/search/go_to_student"
  
  resources :incident_reports do
  	  get :new_report, :on => :collection
  	  get :search, :on => :collection
  	  get :search_results, :on => :collection
  end
  
  match "/incident_reports/search" => "incident_reports#search"
  get "/incident_reports/search"
  
  match "/incident_reports/search_results" => "incident_reports#search_results" 
  get "/incident_reports/search_results"
  
  resources :search
  
  resources :photos

  resources :annotations

  resources :participants

  resources :report_participant_relationships

  resources :staffs

  resources :report_locations

  resources :buildings  do
  	  get :select, :on => :collection
  end
 
  resources :areas  do
  	  get :add_building, :on => :collection
  end
  resources :student_infractions

  resources :relationship_to_reports

  resources :locations

  resources :reports

  resources :students
  
  resources :temp_incident
    
  root :to => "home#landingpage"

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
