module SharedEngine
  class Engine < ::Rails::Engine
    isolate_namespace SharedEngine
  end
end
