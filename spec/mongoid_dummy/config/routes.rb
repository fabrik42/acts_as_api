MongoidDummy::Application.routes.draw do
  mount SharedEngine::Engine => '/shared', :as => 'shared'
end
