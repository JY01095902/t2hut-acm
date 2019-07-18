
require_relative "config.rb"
require_relative "../../factories/aliyun_proxy_factory.rb"
require_relative "../../infra/http_client.rb"

class ConfigMonitor
  def initialize(config)
    @config = config
  end

  def run
    loop do
      puts "start monitoring for #{@config.group}|#{@config.data_id} ..."
      monitor {|is_updated|
        if is_updated
          @config.refresh
          notify_watcher(@config)
        end
      }
      puts "end monitoring..."
    end
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

  def attach_watcher(watcher)
    @watchers = [] if @watchers == nil
    @watchers << watcher
  end

  def detach_watcher(watcher)
    @watchers.delete(watcher)
  end

  def notify_watcher(content)
    @watchers.each{|watcher|
      watcher.update(content)
    } unless @watchers == nil
  end
end