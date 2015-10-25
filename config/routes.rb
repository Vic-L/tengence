Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: "users/sessions",
    registrations: "users/registrations" }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'pages#home'

  # braintree
  get "/braintree_client_token", to: 'brain_tree#client_token'
  get "/upgrade", to: 'brain_tree#upgrade'
  post "/checkout", to: 'brain_tree#checkout'

  get '/current_tenders', to: 'current_tenders#index', as: :current_tenders
end
