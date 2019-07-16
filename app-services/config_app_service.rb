
require_relative "../domain/services/config_service.rb"

class ConfigAppService
  def initialize
    @config_service = ConfigAppService.config_service_class.new
  end

  def get_config(identifier)
    config = @config_service.get_config(identifier)
  end

  def get_all_configs
    @config_service.get_all_configs
  end

  private
  def self.config_service_class
    @config_service_class || ConfigService
  end
end