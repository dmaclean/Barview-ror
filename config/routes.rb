BarviewRor::Application.routes.draw do
  post "fb_update/create"

  get "facebook/create"
  get "facebook/callback"
  delete "facebook/destroy"

  get "forgot_password/index"

  post "forgot_password/create"

  get "viewers/index"

  get "user_questionnaire/index"

  post "user_questionnaire/create"

  get "nearby_bars/index"

  get "about/index"

  get "mobile_info/index"

  get "search/index"

  #get "user_home/index"
  controller :user_home do
    get 'userhome' => :index
  end

  #get "user_login/new"

  #get "user_login/create"

  #get "user_login/destroy"

  resources :favorites

  resources :users

  resources :bar_events
  
  controller :admins do
    get 'adminlogin' => :new
    post 'adminlogin' => :create
    delete 'adminlogout' => :destroy
  end
  
  controller :user_login do
    get 'userlogin' => :new
    post 'userlogin' => :create
    delete 'userlogout' => :destroy
  end

  controller :barlogin do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  #get "barhome/index"
  controller :barhome do
    get 'barhome' => :index
  end

  resources :bars, :barimage

  get "home/index"

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
  # root :to => 'welcome#index'
  root :to => 'user_home#index', :as => 'userhome'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
