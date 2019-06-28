
require_relative "../factories/aliyun_api_factory.rb"
require_relative "../infra/http_client.rb"

class ConfigRepository
  def initialize
    @acm_obj = AliyunAPIFactory.new.create_aliyun_api_object("acm")
  end

  def get_config(group_id, config_id)
    url = @acm_obj.generate_url(group_id, config_id)
    headers = @acm_obj.generate_headers(group_id)

    client = HTTPClient.new
    response = client.get(url, headers)

    return response.body if response.status_code == 200 
    return nil
  end
end