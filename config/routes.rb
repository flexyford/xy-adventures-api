Rails.application.routes.draw do

  match '/sites',  to: 'sites#index', via: :get

  resources :plans, :only => [:create, :edit, :update, :show]

  resources :users, :only => [:create, :destroy, :show, :edit, :update]
  
end
