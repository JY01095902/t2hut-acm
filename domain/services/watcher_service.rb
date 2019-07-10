require "singleton"
require_relative "../../config.rb"

class WatcherService
  include Singleton

  def run_own_watchers(configs)
    configs.each {|config|
      watcher = OWNConfigWatcher.new(config)
      watcher.run {|is_updated|
        if is_updated && @topic_watchers.size > 0
          @topic_watchers.each {|topic_watcher|
            topic_watcher.stop
          }
          run_topic_watchers(OWNConfig::TopicConfig.instance.topics)
        end
      }
      @own_watchers << watcher
    }
  end

  def run_topic_watchers(topics)
    topics.each {|topic|
      config = Config.new(Config.generate_identifier(topic.group, topic.data_id))
      watcher = TopicWatcher.new(config, topic.consumers)
      watcher.run
      @topic_watchers << watcher
    }
  end

  private
  def initialize
    @own_watchers = []
    @topic_watchers = []
  end
end