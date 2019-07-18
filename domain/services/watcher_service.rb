require "singleton"
require "thread"
require_relative "../entities/config.rb"
require_relative "../entities/config_monitor.rb"
require_relative "../entities/config_watcher.rb"

class WatcherService
  include Singleton

  def run_topic_watchers(topics)
    @topic_watchers = []
    topics.each {|topic|
      topic_watcher = Thread.new {
        config = Config.new(Config.generate_identifier(topic.group, topic.data_id))
        config_monitor = ConfigMonitor.new(config)
        topic.consumers.each {|consumer|
          config_monitor.attach_watcher(ConfigWatcher.new(consumer))
        }
        config_monitor.run
      }
      @topic_watchers << topic_watcher
    }
  end

  def restart_topic_watchers(topics)
    @topic_watchers.each {|topic_watcher|
      topic_watcher.kill
    }
    run_topic_watchers(topics)
  end

  def run_own_watchers
    configs = [
      Config.new(Config.generate_identifier("T2HUT", "t2hut.acm.topics")),
      Config.new(Config.generate_identifier("T2HUT", "t2hut.acm.common"))
    ]
    configs.each {|config|
      Thread.new {
        config_monitor = ConfigMonitor.new(config)
        watcher = OwnConfigWatcher.new
        config_monitor.attach_watcher(watcher)
        config_monitor.run
      }
    }
  end
end