Rails.application.routes.draw do

  mount SharedEngine::Engine => "/shared_engine"
end
