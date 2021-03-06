PromanXiv::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  devise_scope :user do
    root to: 'devise/registrations#new'
  end
  devise_for :users, :controllers => { :registrations => "registrations" }
  match 'users/bulk_invite/:quantity' => 'users#bulk_invite', :via => :get, :as => :bulk_invite
  resources :users do
    get 'invite', :on => :member
  end
end