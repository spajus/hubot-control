HubotControl::Application.routes.draw do

  root 'dashboard#index'

  resources :hubots do
    member do
      match 'interact',         via: [:get, :post, :delete]
      match 'interact_stream',  via: [:get, :post]
      match 'configure',        via: [:get, :post]
      match 'log',              via: [:get, :post]
      post  'start'
      post  'stop'
    end
  end

  resource :status, controller: :status

  resources :scripts

end
