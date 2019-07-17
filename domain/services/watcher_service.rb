
require_relative "../entities/config_monitor.rb"
require_relative "../entities/config_watcher.rb"

class WatcherService
  def watch
    config = Config.new("VDJIVVR8Y2lwaGVyLXQyaHV0LnNlcnZpY2UucG9pbnQ=")
    config_monitor = ConfigMonitor.new(config)
    watcher = ConfigWatcher.new
    config_monitor.attach_watcher(watcher)
    config_monitor.run
  end
end