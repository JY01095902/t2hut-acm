require "rack/cors"
require "grape"
require "base64"
require_relative "app-services/config_app_service.rb"

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
    requires :groupCode, type: String
    requires :configId, type: String
  end
  get "groups/:groupCode/configs/:configId" do
    group_code = params[:groupCode]
    config_id = Base64.strict_decode64(params[:configId])
    config_app_service = ConfigAppService.new
    config = config_app_service.get_config(group_code, config_id)

    status :ok
    return config
  end
end
