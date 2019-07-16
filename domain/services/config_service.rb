
require_relative "../entities/config.rb"
require_relative "../../repositories/config_repository.rb"

class ConfigService
  def get_config(identifier)
    group, data_id = Config.parse_identifier(identifier)
    config = Config.new(group, data_id)
  end

  def get_all_configs
    list = ConfigRepository.instance.get_all_content
    configs = []
    list.each {|item|
      configs << Config.new(item["group"], item["dataId"])
    }
    configs
  end
end