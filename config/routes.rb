Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    # scope module: :v1, constraints: ApiConstraints.new(version: 1) do
    namespace :v1 do
      resources :current_tenders
      resources :past_tenders
      resources :watched_tenders do
        collection do
          post 'mass_destroy', to: 'watched_tenders#mass_destroy'
        end
      end
      resources :keywords_tenders
      resources :tenders
      get 'notify_error', to: 'pages#notify_error'
      post 'demo_email', to: 'pages#demo_email'
      get 'demo_tenders', to: 'pages#demo_tenders'
      resources :users do
        collection do
          post 'keywords', to: 'users/keywords#update'
        end
      end
      resources :current_posted_tenders
      resources :past_posted_tenders
    end
  end

  devise_for :users, controllers: { 
    sessions: "users/sessions",
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    passwords:  "users/passwords" }
  devise_scope :user do
    get "users/check_email_taken"=> 'users/registrations#check_email_taken', :as => :check_email_taken
    get "users/check_email_present"=> 'users/registrations#check_email_present', :as => :check_email_present
    get "organizations/register"=> 'users/registrations#new_vendors', as: :new_vendor_registration
    get "register" => "users/registrations#new"
  end

  # static pages
  root 'pages#home'
  get'/', :to => 'pages#home', as: nil
  post 'contact_us_email', to: 'pages#contact_us_email'
  get 'terms-of-service', to: 'pages#terms_of_service'
  get 'refresh_cloudsearch', to: 'pages#refresh_cloudsearch'
  get 'faq', to: 'pages#faq'
  get 'contact', to: 'pages#contact'
  get 'welcome', to: 'pages#welcome'

  # braintree
  # resources :payment_methods, path: '/payment-methods'
  get "/billing", to: 'brain_tree#billing'
  get "/payment-history", to: 'brain_tree#payment_history', as: 'payment_history'
  post "/braintree_slack_pings", to: 'brain_tree#braintree_slack_pings'
  post "/sandbox_braintree_slack_pings", to: 'brain_tree#sandbox_braintree_slack_pings'

  get '/current_tenders', to: 'current_tenders#index', as: :current_tenders
  get '/past_tenders', to: 'past_tenders#index', as: :past_tenders
  get '/current_posted_tenders', to: 'current_posted_tenders#index', as: :current_posted_tenders
  get '/past_posted_tenders', to: 'past_posted_tenders#index', as: :past_posted_tenders
  get '/keywords_tenders', to: 'keywords_tenders#index', as: :keywords_tenders
  post '/update_keywords', to: 'keywords_tenders#update_keywords', as: :update_keywords
  post '/mass_destroy', to: 'watched_tenders#mass_destroy', as: :mass_destroy

  resources :tenders do
    member do
      get 'reveal_buyer_details', to: 'tenders#reveal_buyer_details'
    end
  end
  resources :watched_tenders
  resources :viewed_tenders, only: [:create]
  resources :trial_tenders, only: [:create]

  resource :user do
    get 'keywords', to: 'users/keywords#edit'
    post 'keywords', to: 'users/keywords#update'
  end

  require 'sidekiq/web'
  authenticate :user, lambda { |u| ["john@tengence.com.sg","ganthertay@gmail.com"].include? u.email } do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end
end
