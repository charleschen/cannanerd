Cannanerd::Application.routes.draw do

  
  mount Resque::Server, :at => "/resque"
  delete 'likes/:resource_name/:resource_id' => 'likes#destroy', :as => 'like'
  post 'likes/:resource_name/:resource_id' => 'likes#create', :as => 'like'
  
  resources :users do
    member do
      resources :notifications, :only => [:index]
    end
  end
  match 'login', :to => 'user_sessions#new'
  post 'new_user_session', :to => 'user_sessions#create'
  match 'logout', :to => 'user_sessions#destroy'
  
  resources :clubs
  resources :club_sessions, :only => [:new, :create, :destroy]
  match 'club_logout', :to => 'club_sessions#destroy'
  match 'club_login', :to => 'club_sessions#new'
  
  resources :user_verifications, :only => [:show]

  resources :questionnaires do
    collection {post :sort}
  end
  
  resources :strains do
    collection do
      get :tags, :all_tags
    end  
  end
  
  resources :stock_strains, :only => [:edit,:update,:show,:create,:destroy] do
    member do
      post :make_available
      post :make_unavailable
    end
  end
  
  resources :answers, :only => [:edit,:update,:index]
  resources :quizzes

  root            :to => 'pages#home'
  match 'take_quiz',   :to => 'pages#take_quiz'
  match 'about',  :to => 'pages#about'
  match 'contact', :to => 'pages#contact'
  match 'next_page', :to => 'pages#next_page'
  
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
