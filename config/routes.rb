FPBL::Application.routes.draw do

  # This line mounts Forem's routes at /forums by default.
  # This means, any requests to the /forums URL of your application will go to Forem::ForumsController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Forem relies on it being the default of "forem"
  mount Forem::Engine, at: '/forums'

  devise_for :owners

  get 'pages/index'

  match '/team/:id/(:year)' => 'team#index', as: 'team'
  match '/standings/(:year)' => 'pages#standings', as: 'standings'
  match '/calendar/(:month)/(:year)' => 'pages#calendar', as: 'calendar'
  match '/draft/(:year)' => 'draft#index', as: 'draft'
  match '/transaction/' => 'pages#transaction', as: 'transaction'
  match '/rules/' => 'pages#rules', as: 'rules'
  match '/rookies/' => 'pages#rookies', as: 'rookies'
  match '/freeagents/' => 'pages#freeagents', as: 'freeagents'
  match '/overview/' => 'overview#index', as: 'overview'
  match '/ranking/owners/' => 'owner_ranking#index', as: 'owner_ranking'
  match '/ranking/daily/' => 'power_ranking#index', as: 'power_ranking'
  match '/records/(:year)' => 'records#index', as: 'records'
  match '/player/(:id)' => 'player#index', as: 'player'
  match '/leaders/current/(:league)/(:year)' => 'leaders#current', as: 'current_leaders'
  match '/leaders/career/' => 'leaders#career', as: 'career_leaders'
  match '/leaders/season/' => 'leaders#season', as: 'season_leaders'

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
  root to: 'pages#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
