
require "thread"
require 'singleton'
require_relative "../domain/entities/config.rb"
require_relative "../domain/entities/watcher.rb"
require_relative "../domain/services/config_service.rb"
require_relative "../config.rb"
require_relative "../domain/services/watcher_service.rb"

class WatcherAppService
  include Singleton

  def watch
    watch_own_configs
    watch_topics
  end

  private
  def watch_topics
    topic_config = OWNConfig::TopicConfig.instance
    watcher_service = WatcherService.instance
    watcher_service.run_topic_watchers(topic_config.topics)
  end

  def watch_own_configs
    configs = [Config.new("T2HUT", "t2hut.acm.topics")]
    watcher_service = WatcherService.instance
    watcher_service.run_own_watchers(configs)
  end
end