RailsApp::Application.routes.draw do

  resources :users do
    member do
      get 'show_default'
    end
  end

  resources :respond_with_users do
    member do
      get 'show_default'
    end
  end

end
