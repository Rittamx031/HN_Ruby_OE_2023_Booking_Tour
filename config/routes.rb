require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :users , controllers: {sessions: "devise/sessions",
                                    registrations: "devise/registrations",
                                    confirmations: "devise/confirmations",
                                    omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /en|vi/ do
    resources :tours, only: %i(index show)
    resources :users, only: %i(index show)
    resources :bookings, only: %i(create cancel show booking_following) do
      resources :reviews, only: %i(new create)
    end
    as :user do
      get "signin" => "devise/sessions#new", as: "login"
      post "signin" => "devise/sessions#create"
      get "edit_profile" => "devise/registrations#edit"
      delete "signout" => "devise/sessions#destroy"
      get "signup" => "devise/registrations#new"
    end
    resources :reviews , only: %i(destroy edit update)
    root "tours#index"
    get "home" => "tours#home"
    get "cancel_booking/:id" => "bookings#cancel", as: "cancel_booking"
    get "book/:id" => "bookings#new", as: "book"
    get "booking_history" => "bookings#booking_history", as:"history"
    get "tour_following" => "tours#following_tour", as: "tour_following"
    get "follow/:id" => "relationships#create", as: "follow_tour"
    get "review/:id" => "reviews#new", as: "review_tour"
    delete "unfollow/:id" => "relationships#destroy", as: "unfollow_tour"
    get "tour_category/:tour_category_id" => "tours#tour_category", as: "tour_by_tour_category"
    namespace :admin do
      resources :tours, :tour_details, :homes, :tour_categories
      resources :bills, only: %i(index cancel confirm)
      mount Sidekiq::Web => "/sidekiq"
      resources :charts do
        collection do
          get "incomes"
          get "status_booking"
          get "users_signup"
          get "new_booking"
        end
      end
      get "dashboard"=> "homes#home", as: "dashboard"
      get "/tour/:id/tourdetails" => "tour_details#new", as: "add_tour_detail"
      get "cancel_booking/:id" => "bills#cancel_modal", as: "cancel_booking"
      put "confirm_booking/:id" => "bills#confirm", as: "confirm_booking"
      post "submit_cancel/:id" => "bills#submit_cancel", as: "submit_cancel"
      post "/charts/filter" => "charts#filter", as: "chart_filter"
    end
  end
end
