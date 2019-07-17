
require_relative "config.rb"
require_relative "../../factories/aliyun_proxy_factory.rb"
require_relative "../../infra/http_client.rb"

module Observer
  def attach(observer)
    @observers = [] if @observer == nil
    @observers << observer
  end

  def Detach(observer)
    @observers.delete(observer)
  end

  def notify(content)
    @observers.each{|observer|
      observer.update(content)
    } unless @observers == nil
  end
end

class ConfigMonitor
  include Observer

  def initialize(config)
    @config = config
  end

  def run
    monitor {|is_updated|
      if is_updated
        @config.refresh
        notify(@config.content)
      end
    }
  end

  def monitor(&callback)
    acm_proxy = AliyunProxyFactory.new.create_aliyun_proxy("acm")
    url, data = acm_proxy.generate_listen_url(@config.group, @config.data_id, @config.content)
    headers = acm_proxy.generate_listen_headers(@config.group)
    response = HTTPClient.post(url, data, headers)
    if response.status_code == 200
      callback.call(!response.body.empty?)
    else
      puts "Problems encountered while listening for configuration changes. Error: #{response.body}"
    end
  end  
end