Rails.application.routes.draw do
  get 'tweets/index'
  get 'tweets/show'
  get 'tweets/new'
  post 'tweets' => 'tweets#create'
  get 'users/index'
  get 'users/show/:username' => 'users#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'hello/helloworld', to: 'hello#helloworld'
end
