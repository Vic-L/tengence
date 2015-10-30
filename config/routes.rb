Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords:  "users/passwords" }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'pages#home'

  # braintree
  get "/braintree_client_token", to: 'brain_tree#client_token'
  get "/upgrade", to: 'brain_tree#upgrade'
  post "/checkout", to: 'brain_tree#checkout'

  get '/current_tenders', to: 'current_tenders#index', as: :current_tenders
  get '/past_tenders', to: 'past_tenders#index', as: :past_tenders
  get '/keywords_tenders', to: 'keywords_tenders#index', as: :keywords_tenders

  resources :tenders
  resources :watched_tenders

  resource :user do
    get 'keywords', to: 'users/keywords#edit'
    post 'keywords', to: 'users/keywords#update'
  end
end
