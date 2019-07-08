require "rack/cors"
require "grape"
require_relative "app-services/config_app_service.rb"
require_relative "infra/api_result.rb"

class API < Grape::API
  use Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: [:get, :post, :delete, :put, :patch, :options]
    end
  end
  format :json

  get :ping do
    { result: "pong" }
  end

  params do
    requires :identifier, type: String
  end
  get "configs/:identifier" do
    identifier = params[:identifier]
    config_app_service = ConfigAppService.new
    config = config_app_service.get_config(identifier)

    status :ok
    APISingleResult.create(config)
  end

  get :configs do
    config_app_service = ConfigAppService.new
    configs = config_app_service.get_all_configs

    status :ok
    APIArrayResult.create(configs, configs.size)
  end
end
