
require_relative "../entities/config.rb"

class ConfigService
  def get_config(group_id, config_id)
    config = Config.new(group_id, config_id)
  end
end