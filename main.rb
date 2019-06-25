require "rack/cors"
require "grape"
require "base64"

class API < Grape::API
  # use Configuration
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
    group_id = params[:groupId]
    config_id = Base64.strict_decode64(params[:configId])

    status :ok
    return {
        group_id: group_id,
        config_id: config_id,
    }
  end
end
