
require "logger"
require_relative "main.rb"
require_relative "app-services/watcher_app_service.rb"

logger = Logger.new(STDERR)
logger.info("runtime env: #{ENV["T2HUT_ACM_ENV"]}")

# WatcherAppService.instance.watch

run API