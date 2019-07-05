require "rack/cors"
require "grape"
require "base64"
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
    return { result: "pong" }
  end

  params do
    requires :groupId, type: String
    requires :configId, type: String
  end
  get "groups/:groupId/configs/:configId" do
    group = params[:groupId]
    config_id = Base64.strict_decode64(params[:configId])
    config_app_service = ConfigAppService.new
    config = config_app_service.get_config(group, config_id)

    status :ok
    return config
  end

  get :configs do
    config_app_service = ConfigAppService.new
    # configs = []
    # config_app_service.get_all_configs.each {|config|
    #   configs << {
    #     identifier: config.identifier,
    #     data_id: config.data_id,
    #     group: config.group,
    #     content: config.content
    #   }
    # }

    configs = config_app_service.get_all_configs

    status :ok
    return APIResult.get_array_template(configs, configs.size)
  end
end
