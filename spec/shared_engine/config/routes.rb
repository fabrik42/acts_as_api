SharedEngine::Engine.routes.draw do
  resources :users do
    collection do
      get 'index_meta'
      get 'index_relation'
    end
    member do
      get 'show_meta'
      get 'show_default'
      get 'show_prefix_postfix'
    end
  end

  resources :respond_with_users do
    collection do
      get 'index_meta'
      get 'index_relation'
      get 'index_no_root_no_order'
    end
    member do
      get 'show_meta'
      get 'show_default'
      get 'show_prefix_postfix'
    end
  end
end
