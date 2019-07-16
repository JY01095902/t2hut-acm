require 'singleton'
require_relative "../factories/aliyun_proxy_factory.rb"

class ConfigRepository
  include Singleton

  def get_content(group, data_id)
    acm_proxy = AliyunProxyFactory.new.create_aliyun_proxy("acm")
    acm_proxy.get_config(group, data_id)
  end

  def get_all_content
    acm_proxy = AliyunProxyFactory.new.create_aliyun_proxy("acm")
    acm_proxy.get_all_configs
  end
end