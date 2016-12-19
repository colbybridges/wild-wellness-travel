Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root to: 'pages#home'
  get 'landing' => 'pages#landing'

  resources :companies, only: [:new, :create]
  get 'company_dashboard' => 'companies#dashboard'

  resources :retreats, only: [:new, :create, :edit, :update, :destroy]

  mount Attachinary::Engine => "/attachinary"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
