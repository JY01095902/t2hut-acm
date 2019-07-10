
require "thread"
require "json"
require_relative "config.rb"
require_relative "../../infra/http_client.rb"
require_relative "../../factories/aliyun_proxy_factory.rb"

class Watcher
  attr_reader :config

  def initialize(config)
    @config = config
    @watcher_thread = nil
  end

  def run
    puts "Need subclass implementation."
  end

  def stop
    puts "--------------stop listen for #{@config.group}|#{@config.data_id}---------------------------"
    @watcher_thread.kill unless @watcher_thread == nil
  end

  def restart
    puts "--------------restart listen for #{@config.group}|#{@config.data_id}---------------------------"
    stop
    run
  end

  private
  def listen(&callback)
    acm_proxy = AliyunProxyFactory.new.create_aliyun_proxy("acm")
    acm_proxy.get_config(@config.group, @config.data_id)
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

class TopicWatcher < Watcher
  attr_reader :consumers

  def initialize(config, consumers)
    super(config)
    @consumers = consumers
  end

  def run
    @watcher_thread = Thread.new {
      loop do
        listen {|is_updated|
          puts "--------------start listen for #{@config.group}|#{@config.data_id}---------------------------"
          @consumers.each {|consumer|
            push(consumer.endpoint)
          } if is_updated && @consumers.size > 0
          puts "--------------end---------------------------"
        }
      end
    }
  end

  def push(endpoint)
    @config.refresh
    data = {
      event_name: "ConfigUpdated",
      payload: {
        config_id: @config.identifier,
        group: @config.group,
        data_id: @config.data_id
      }
    }
    puts "pushing new config... JSON(data) ----- #{JSON(data)}"
    response = HTTPClient.post(endpoint, JSON(data), { "Content-Type" => "application/json" })
    if response.status_code != 200
      puts "Problems encountered while pushing new configuration to #{endpoint}. Error: #{response.body}"
    end
  end
end

class OWNConfigWatcher < Watcher
  def initialize(config)
    super(config)
  end

  def run
    @watcher_thread = Thread.new {
      loop do
        listen {|is_updated|
          puts "--------------start listen for own configs(#{@config.group}|#{@config.data_id})---------------------------"
          if is_updated
            @config.refresh
            OWNConfig::TopicConfig.instance.refresh 
            puts "updated own configs."
            yield(is_updated) if block_given?
          end
          puts "--------------end---------------------------"
        }
      end
    }
  end
end