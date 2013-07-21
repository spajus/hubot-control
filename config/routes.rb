HubotControl::Application.routes.draw do

  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  root 'dashboard#index'

  resources :hubots do
    member do
      match 'interact',         via: [:get, :post, :delete]
      match 'interact_stream',  via: [:get, :post]
      match 'configure',        via: [:get, :post]
      match 'log',              via: [:get, :post]
      match 'log_truncate',     via: [:post]
      post  'start'
      post  'stop'
    end
  end

  resource :status, controller: :status

  resource :scripts do
    get :index
    match :edit, via: [:get, :post]
  end

end
