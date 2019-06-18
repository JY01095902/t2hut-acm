require_relative "main.rb"
require "logger"

logger = Logger.new(STDERR)
logger.info("runtime env: #{ENV["T2HUT_ACM_ENV"]}")

run API