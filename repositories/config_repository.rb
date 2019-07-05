
require_relative "../factories/aliyun_proxy_factory.rb"
require_relative "../infra/http_client.rb"

class ConfigRepository
  def get_config(group, data_id)
    acm_proxy = AliyunProxyFactory.new.create_aliyun_proxy("acm")
    acm_proxy.get_config(group, data_id)
  end

  def get_all_configs
    
  end
end