require_relative "../objects/topic.rb"
require_relative "../../own_config.rb"
require_relative "../services/watcher_service.rb"

class ConfigWatcher
  def initialize(consumer)
    @endpoint = consumer.endpoint
  end

  def update(config)
    puts "#{ConfigWatcher}发现被观察者变了,#{config.content}, ready to push to #{@endpoint}."
  end
end

class OwnConfigWatcher
  def update(config)
    puts "#{OwnConfigWatcher}发现被观察者变了,#{config.content}"
    own_config = OwnConfig.instance
    own_config.update_topics(config)
    WatcherService.instance.restart_topic_watchers(own_config.topics)
  end
end