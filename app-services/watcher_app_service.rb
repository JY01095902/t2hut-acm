
require "thread"
require_relative "../domain/entities/config.rb"
require_relative "../domain/entities/watcher.rb"
require_relative "../domain/services/config_service.rb"

class WatcherAppService
  def self.run_watchers
    configs = []
    configs << Config.new(Config.generate_identifier("BODLEIAN", "cipher-t2hut.bodleian.catalog.oss"))
    configs << Config.new(Config.generate_identifier("T2HUT", "cipher-t2hut.service.point"))
    configs << Config.new(Config.generate_identifier("T2HUT", "t2hut-acm-customers"))

    # configs << Config.new("Qk9ETEVJQU58Y2lwaGVyLXQyaHV0LmJvZGxlaWFuLmNhdGFsb2cub3Nz")
    # configs << Config.new("VDJIVVR8Y2lwaGVyLXQyaHV0LnNlcnZpY2UucG9pbnQ=")
    # configs << Config.new("VDJIVVR8dDJodXQtYWNtLWN1c3RvbWVycw==")

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