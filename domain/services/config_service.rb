
require_relative "../entities/config.rb"
require_relative "../../factories/aliyun_proxy_factory.rb"

class ConfigService
  def get_config(identifier)
    config = Config.new(identifier)
  end

  def get_all_configs
    acm_proxy = AliyunProxyFactory.new.create_aliyun_proxy("acm")
    list = acm_proxy.get_all_configs
    configs = []
    list.each {|item|
      configs << Config.new(Config.generate_identifier(item["group"], item["dataId"]))
    }
    configs
  end
end