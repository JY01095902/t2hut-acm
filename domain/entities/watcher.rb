
require_relative "../../infra/http_client.rb"
require_relative "../../factories/aliyun_proxy_factory.rb"
require_relative "config.rb"

class Watcher
  attr_reader :config
  attr_reader :is_watching

  def initialize(config)
    @config = config
  end

  def watch(mode, &callback)
    if mode == "once"
      listen(&callback)
    elsif mode = "always"
      loop do
        listen(&callback)
        @config.refresh
      end
    else
      puts "#{mode} mode is not supported. Support only 'once' or 'always'."
    end
  end

  private
  def listen(&callback)
    acm_proxy = AliyunProxyFactory.new.create_aliyun_proxy("acm")
    acm_proxy.get_config(@config.group_id, @config.data_id)
    url, data = acm_proxy.generate_listen_url(@config.group_id, @config.data_id, @config.content)
    headers = acm_proxy.generate_listen_headers(@config.group_id)
    response = HTTPClient.post(url, data, headers)
    callback.call(!response.body.empty?) if response.status_code == 200
  end
end