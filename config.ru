
require_relative "main.rb"
require_relative "app-services/watcher_app_service.rb"
require_relative "infra/logger.rb"

Log.info("runtime env: #{ENV["T2HUT_ENV"]}")

WatcherAppService.instance.watch

run API