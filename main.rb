require "rack/cors"
require "grape"

class API < Grape::API
  # use Configuration
  use Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: [:get, :post, :delete, :put, :patch, :options]
    end
  end
  format :json
  prefix :configs

  get :ping do
    return { result: "pong" }
  end
end
