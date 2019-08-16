require_relative "../objects/topic.rb"
require_relative "../../own_config.rb"
require_relative "../services/watcher_service.rb"
require "json"

class ConfigWatcher
  def initialize(consumer)
    @endpoint = consumer.endpoint
  end

  def update(config)
    puts "#{ConfigWatcher}发现被观察者变了,#{config.content}, ready to push to #{@endpoint}."
    data = {
      event_name: "ConfigUpdated",
      payload: {
        config_id: config.identifier,
        group: config.group,
        data_id: config.data_id,
      }
    }
    headers = {
      "Content-Type": "application/json"
    }
    response = HTTPClient.post(@endpoint, data.to_json, headers)
    puts "配置更新消息发送完毕，返回结果：#{response.status_code}, body：#{response.body}."
  end
end

class OwnConfigWatcher
  def update(config)
    own_config = OwnConfig.instance
    if config.data_id == "t2hut.acm.topics"
      puts "#{OwnConfigWatcher}发现#{config.data_id}变了, #{config.content}"
      own_config.update_topics(config)
      WatcherService.instance.restart_topic_watchers(own_config.topics)
    elsif config.data_id == "t2hut.acm.common"
      puts "#{OwnConfigWatcher}发现#{config.data_id}变了, #{config.content}"
      own_config.update_common(config)
    else
      puts "#{OwnConfigWatcher}发现#{config.data_id}变了"
    end
  end
end