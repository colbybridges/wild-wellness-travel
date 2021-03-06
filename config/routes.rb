Rails.application.routes.draw do

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root to: 'pages#home'
  get 'landing' => 'pages#landing'
  get 'about' => 'pages#about'
  get 'blog' => 'pages#blog'

  resources :properties
  resources :retreat_leaders
  resources :retreats do
    resources :meal_plans, only: [:show, :new, :create, :edit, :update, :destroy]
  end
  resources :bookings
  resources :reviews

  # Admin
  get 'property_list' => 'site_admin#property_list'
  get 'leader_list' => 'site_admin#leader_list'
  get 'retreat_list' => 'site_admin#retreat_list'
  put 'activate_property/:id' => 'site_admin#activate_property', as: "activate_property"
  put 'activate_leader/:id' => 'site_admin#activate_leader', as: "activate_leader"
  put 'activate_retreat/:id' => 'site_admin#activate_retreat', as: "activate_retreat"

  mount Attachinary::Engine => "/attachinary"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
