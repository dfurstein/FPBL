FPBL::Application.routes.draw do

  devise_for :owners

  get 'pages/index'

  match '/team/:id/(:year)', to: 'team#index', as: 'team'
  match '/standings/(:year)', to: 'pages#standings', as: 'standings'
  match '/calendar/(:month)/(:year)', to: 'pages#calendar', as: 'calendar'
  match '/draft/(:year)', to: 'draft#index', as: 'draft'
  match '/transaction/', to: 'pages#transaction', as: 'transaction'
  match '/rules/', to: 'pages#rules', as: 'rules'
  match '/rookies/', to: 'pages#rookies', as: 'rookies'
  match '/freeagents/', to: 'pages#freeagents', as: 'freeagents'
  match '/overview/', to: 'overview#index', as: 'overview'
  match '/ranking/owners/', to: 'owner_ranking#index', as: 'owner_ranking'
  match '/ranking/daily/', to: 'power_ranking#index', as: 'power_ranking'
  match '/records/(:year)', to: 'records#index', as: 'records'
  match '/player/(:id)', to: 'player#index', as: 'player'
  match '/leaders/current/(:league)/(:year)', to: 'leaders#current', as: 'current_leaders'
  match '/leaders/career/', to: 'leaders#career', as: 'career_leaders'
  match '/leaders/season/', to: 'leaders#season', as: 'season_leaders'
  match '/extensions', to: 'extensions#index', as: 'extensions'
  match '/releases', to: 'releases#index', as: 'releases'

  post 'extensions/add', to: 'extensions#add', as: 'add_extensions'
  
  post 'releases/add', to: 'releases#add', as: 'add_release'
  delete 'releases/delete', to: 'releases#delete', as: 'delete_release'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id', to: 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase', to: 'catalog#purchase', :as, to: :purchase
  # This route can be invoked with purchase_url(:id, to: product.id)

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
  #       get 'recent', :on, to: :collection
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
  # root :to, to: 'welcome#index'
  root to: 'pages#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
