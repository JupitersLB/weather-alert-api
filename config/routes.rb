Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: %i[create show update destroy] do
    resources :tokens, only: %i[create update destroy]
    post '/login', to: 'users#login', as: :user_login, on: :collection
  end

  get '/forecast', to: 'weathers#forecast', as: :forecast
end
