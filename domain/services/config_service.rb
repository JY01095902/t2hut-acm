
require_relative "../entities/config.rb"
require_relative "../../repositories/config_repository.rb"

class ConfigService
  def get_config(identifier)
    config = Config.new(identifier)
  end

  def get_all_configs
    list = ConfigRepository.instance.get_all_content
    configs = []
    list.each {|item|
      identifier = Config.generate_identifier(item["group"], item["dataId"])
      configs << Config.new(identifier)
    }
    configs
  end
end