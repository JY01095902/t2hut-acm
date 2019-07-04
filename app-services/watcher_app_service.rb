
require "thread"
require_relative "../domain/entities/config.rb"
require_relative "../domain/entities/watcher.rb"
require_relative "../domain/services/config_service.rb"

class WatcherAppService
  def self.run_watchers
    configs = []
    configs << Config.new("BODLEIAN", "cipher-t2hut.bodleian.catalog.oss")
    configs << Config.new("T2HUT", "cipher-t2hut.service.point")
    configs << Config.new("T2HUT", "t2hut-acm-customers")

    configs.each {|config|
      Thread.new {
        watcher = Watcher.new(config)
        watcher.watch("always") {|is_updated|
          puts "--------------start---------------------------"
          if is_updated 
            puts "#{config.data_id} is updated."
            config.refresh
            puts "new content is: #{config.content}."
          else 
            puts "#{config.data_id} is not updated."
          end
          puts "---------------end---------------------------"
        }
      }
    }
  end
end