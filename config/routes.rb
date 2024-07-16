Rails.application.routes.draw do
  get 'tags/index'
  get 'tags/show'
  require 'sidekiq/web'
  require 'admin_constraint'

  # Sidekiq admin interface
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  # Root route
  root 'index#index'

  # Error routes
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Authentication routes
  post 'signup', to: 'users#create', as: 'signup'
  post 'login', to: 'sessions#create', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'get-started', to: 'index#buy_sell', as: 'get_started'

  # Mobile routes
  get 'mobile', to: 'sessions#mobile', as: 'mobile'
  get 'mobile/signup', to: 'sessions#mobile_signup'
  get 'mobile/login', to: 'sessions#mobile_login'
  get 'welcome-back', to: 'sessions#welcome_back_user', as: 'welcome_back_user'

  # Password routes
  get 'forgot-my-password', to: 'users#forgot_my_password'
  post 'send-token-email', to: 'users#send_token_email'
  get 'new-token-email', to: 'users#new_token_confirmation'
  get 'validate-token/:token', to: 'users#validate_token'
  post 'update-password', to: 'users#update_password'
  post 'change-password', to: 'users#change_password'
  get 'complete_signup/:token', to: 'users#complete_signup'

  # Index page routes
  get 'background', to: 'index#background'
  get 'about', to: 'index#about'
  get 'faq', to: 'index#faq'
  get 'contact', to: 'index#contact'
  post 'contact', to: 'admin#contact_team', as: 'contact_us'
  get 'step-by-step', to: 'index#step_by_step', as: 'guide'
  get 'privacy-policy', to: 'index#policy', as: 'policy'
  get 'ipad', to: 'index#device_warning'

  # Terms and conditions
  get 'terms-and-conditions', to: 'index#terms_and_conditions'
  get 'accept/:user_id', to: 'users#accept', as: 'accept'

  # Resourceful routes
  resources :users
  resources :sessions, only: %i[new create destroy]
  resources :apartments do
    resources :comments, only: [:create]
    resources :photo_descriptions, only: [:update]
    resources :market_scores, only: [:create]
    resources :floorplans, only: %i[create destroy update]
  end
  resources :favourites
  resources :photos
  resources :replies
  # config/routes.rb
  resources :tags, param: :slug do
    resources :child_tags, only: [:show], param: :slug, controller: 'tags'
  end


  # Apartment search routes
  get 'sub-search', to: 'apartments#index', constraints: lambda { |request| request.query_parameters[:commit] == 'SEARCH' }, as: 'search_page_two'
  get 'search-page', to: 'apartments#search_page_one', as: 'search_page_one'
  get 'search_location/:data', to: 'apartments#search_location'
  get 'submit', to: 'apartments#submit', as: 'submit'
  get 'location-data', to: 'postcodes#typeahead_data'
  get 'property-search', to: 'apartments#new_index'
  get 'location', to: 'apartments#new'
  get 'myproperties', to: 'apartments#owner'
  get 'saved_search/:id', to: 'apartments#index', as: 'saved_search'
  get 'search', to: 'apartments#search'
  get 'searches', to: 'apartments#return_to_search_results', as: 'return_to_search_results'
  get 'photos/featured', to: 'photos#featured'

  # Comments, replies & likes
  post 'comments/:id/:user_id', to: 'apartments#comment'
  delete 'comments/:id', to: 'comments#delete', as: 'delete_comment'
  post 'like/:like_id', to: 'comments#like', as: 'like_comment'

  # Admin section
  get 'admin', to: 'admin#index', as: 'admin'
  post 'approve/:id', to: 'admin#approve', as: 'approval'
  post 'revoke/:id', to: 'admin#revoke', as: 'revoke'
  delete 'admin/delete/:id', to: 'admin#delete', as: 'admin_deletion'
  post 'admin/archive/:id', to: 'admin#archive', as: 'admin_archive'
  post 'admin/unarchive/:id', to: 'admin#unarchive', as: 'admin_unarchive'
  get 'admin/archival', to: 'admin#archival', as: 'archival'
  get 'admin/owner/:user_id', to: 'admin#owner', as: 'admin_owner'
  delete 'delete_saved_search/:id', to: 'searches#delete', as: 'delete_saved_search'
  namespace :admin do
    resources :tags
  end

  get "up" => "rails/health#show", as: :rails_health_check
  # Catch-all route for 404 errors
  # match '*path', to: 'errors#not_found', via: :all
end
