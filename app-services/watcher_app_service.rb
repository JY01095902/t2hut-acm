
require "thread"
require_relative "../domain/entities/config.rb"
require_relative "../domain/entities/watcher.rb"
require_relative "../domain/services/config_service.rb"
require_relative "../config.rb"

class WatcherAppService
  @@watchers = []

  def self.run_own_watchers
    configs = []
    configs << Config.new(Config.generate_identifier("T2HUT", "t2hut.acm.topics"))

    configs.each {|config|
      Thread.new {
        watcher = Watcher.new(config)
        watcher.watch("always") {|is_updated|
          puts "--------------start own---------------------------"
          if is_updated 
            puts "#{config.data_id} is updated."
            config.refresh
            OWNConfig::TopicConfig.instance.refresh
            WatcherAppService.restart_consumer_watchers
            puts "new content is: #{config.content}."
          else 
            puts "#{config.data_id} is not updated."
          end
          puts "---------------end own---------------------------"
        }
      }
    }
  end

  def self.run_consumer_watchers
    topic_config = OWNConfig::TopicConfig.instance
    topic_config.topics.each {|topic|
      @@watchers << Thread.new {
        config = Config.new(Config.generate_identifier(topic.group, topic.data_id))
        watcher = Watcher.new(config)
        watcher.watch("always") {|is_updated|
          puts "--------------start---------------------------"
          if is_updated 
            puts "#{config.data_id} is updated."
            topic.consumers.each{|consumer|
              config.refresh
              config.push(consumer.endpoint)
            }
            puts "new content is: #{config.content}."
          else 
            puts "#{config.data_id} is not updated."
          end
          puts "---------------end---------------------------"
        }
      }
    }
  end

  def self.run_watchers
    WatcherAppService.run_own_watchers
    WatcherAppService.run_consumer_watchers
  end

  def self.restart_consumer_watchers
    @@watchers.each{|thread|
      thread.kill
    }
    @@watchers = []
    WatcherAppService.run_consumer_watchers
  end
end