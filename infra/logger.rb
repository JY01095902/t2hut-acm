
require "logger"

class Log
  @logger = Logger.new(STDERR)

  def self.info(content)
    @logger.info(content)
  end
end