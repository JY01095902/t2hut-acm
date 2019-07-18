
require 'singleton'
require_relative "../own_config.rb"
require_relative "../domain/services/watcher_service.rb"

class WatcherAppService
  include Singleton

  def watch
    watch_own_configs
    watch_topics
  end

  private
  def watch_topics
    own_config = OwnConfig.instance
    watcher_service = WatcherService.instance
    watcher_service.run_topic_watchers(own_config.topics)
  end

  def watch_own_configs
    watcher_service = WatcherService.instance
    watcher_service.run_own_watchers
  end
end