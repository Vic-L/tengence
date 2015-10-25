Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: "users/sessions",
    registrations: "users/registrations" }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'pages#home'

  # braintree
  get "/braintree_client_token", to: 'brain_tree#client_token'
end
