Rails.application.routes.draw do

  constraints DomainConstraint.new('tengence.com.sg') do
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
    # root 'pages#home'
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
    get "/plans", to: 'brain_tree#plans'
    get "/subscribe-monthly", to: 'brain_tree#subscribe', as: 'subscribe_one_month', defaults: {plan: 'one_month_plan'}
    get "/subscribe-quarterly", to: 'brain_tree#subscribe', as: 'subscribe_three_months', defaults: {plan: 'three_months_plan'}
    get "/subscribe-annually", to: 'brain_tree#subscribe', as: 'subscribe_one_year', defaults: {plan: 'one_year_plan'}
    get "/change-payment", to: 'brain_tree#change_payment', as: 'change_payment'
    get "/edit-payment", to: 'brain_tree#edit_payment', as: 'edit_payment'
    post "/create-payment", to: 'brain_tree#create_payment', as: 'create_payment'
    post "/update-payment", to: 'brain_tree#update_payment', as: 'update_payment'
    get "/payment-history", to: 'brain_tree#payment_history', as: 'payment_history'
    post "/unsubscribe", to: 'brain_tree#unsubscribe', as: 'unsubscribe'
    post "/toggle-renew", to: 'brain_tree#toggle_renew', as: 'toggle_renew'
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

  # Phase2
  # TrackTango
  constraints DomainConstraint.new('utrade.pw') do
    get'/', :to => 'pages#faq', as: nil
    get '/services/landscaping', to: 'pages#landscaping', as: :landscaping
    get '/services/security', to: 'pages#security', as: :security
    get '/services/pest-control', to: 'pages#pest_control', as: :pest_control
    get '/services/swimming-pool', to: 'pages#swimming_pool', as: :swimming_pool
    get '/services/commerical-cleaning', to: 'pages#commerical_cleaning', as: :commerical_cleaning
    get '/services/cctv', to: 'pages#cctv', as: :cctv
    get '/services/gates-barriers', to: 'pages#gates_barriers', as: :gates_barriers
    get '/services/gym-contractors', to: 'pages#gym_contractors', as: :gym_contractors
    get '/services/private-investigators', to: 'pages#private_investigators', as: :private_investigators
    get '/services/office-renovation-interior-design', to: 'pages#office_renovation_interior_design', as: :office_renovation_interior_design
    get '/services/events-management', to: 'pages#events_management', as: :events_management
    get '/services/catering', to: 'pages#catering', as: :catering
    get '/services/printing', to: 'pages#printing', as: :printing
  end
end
